library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;
use work.misc.ALL;

entity register_file_wrapper is
	port (
		clk : in  std_logic;
		annodes : out std_logic_vector(7 downto 0);
		cathodes : out std_logic_vector(7 downto 0);
		buttons : in std_logic_vector(4 downto 0); -- 4 center down up right left 0
		switches : in std_logic_vector(15 downto 0)
	);
end entity register_file_wrapper;

architecture behav of register_file_wrapper is

	constant ssg_digit_0 : std_logic_vector(6 downto 0) := "1111110";
	constant ssg_digit_1 : std_logic_vector(6 downto 0) := "0110000";
	constant ssg_digit_2 : std_logic_vector(6 downto 0) := "1101101";
	constant ssg_digit_3 : std_logic_vector(6 downto 0) := "1111001";
	constant ssg_digit_4 : std_logic_vector(6 downto 0) := "0110011";
	constant ssg_digit_5 : std_logic_vector(6 downto 0) := "1011011";
	constant ssg_digit_6 : std_logic_vector(6 downto 0) := "1011111";
	constant ssg_digit_7 : std_logic_vector(6 downto 0) := "1110000";
	constant ssg_digit_8 : std_logic_vector(6 downto 0) := "1111111";
	constant ssg_digit_9 : std_logic_vector(6 downto 0) := "1111011";
	constant ssg_digit_A : std_logic_vector(6 downto 0) := "1110111";
	constant ssg_digit_B : std_logic_vector(6 downto 0) := "0011111";
	constant ssg_digit_C : std_logic_vector(6 downto 0) := "1001110";
	constant ssg_digit_D : std_logic_vector(6 downto 0) := "0111101";
	constant ssg_digit_E : std_logic_vector(6 downto 0) := "1001111";
	constant ssg_digit_F : std_logic_vector(6 downto 0) := "1000111";

	constant rf_word_size : integer := 8;
	constant rf_size 	  : integer := 16;
	constant rf_log_size  : integer := 4;

	signal rf_addr_a : std_logic_vector(rf_log_size-1 downto 0);
	signal rf_addr_b : std_logic_vector(rf_log_size-1 downto 0);
	signal rf_addr_c : std_logic_vector(rf_log_size-1 downto 0);
	signal rf_data_a : std_logic_vector(rf_word_size-1 downto 0);
	signal rf_data_b : std_logic_vector(rf_word_size-1 downto 0);
	signal rf_data_c : std_logic_vector(rf_word_size-1 downto 0);
	signal rf_w_en   : std_logic;

	signal ssd_value : std_logic_vector(4 downto 0);
	signal ssd_controls : std_logic_vector(7 downto 0);
	signal ssd_data : std_logic_vector(31 downto 0);
	signal ssd_enable : std_logic_vector(7 downto 0);
	signal r_clock_div, clock_div : std_logic_vector (16 downto 0); -- about one turnover per ms
	signal current_segment, r_current_segment : std_logic_vector(7 downto 0);
	signal data_next, r_data : std_logic_vector(31 downto 0);
	signal rst : std_logic;
	signal bcd : std_logic_vector(11 downto 0);
	
begin

	rst <= buttons(3); -- down

	ssd_control: process (ssd_value)
		variable v : std_logic_vector(6 downto 0);
		variable t : std_logic_vector(3 downto 0);
	begin
		t := ssd_value(3 downto 0);
		v := "0000000";
		if t = "0000" then
			v := "1111110";
		elsif t = "0001" then
			v := "0110000";
		elsif t = "0010" then
			v := "1101101";
		elsif t = "0011" then
			v := "1111001";
		elsif t = "0100" then
			v := "0110011";
		elsif t = "0101" then
			v := "1011011";
		elsif t = "0110" then
			v := "1011111";
		elsif t = "0111" then
			v := "1110000";
		elsif t = "1000" then
			v := "1111111";
		elsif t = "1001" then
			v := "1111011";
		elsif t = "1010" then
			v := "1110111";
		elsif t = "1011" then
			v := "0011111";
		elsif t = "1100" then
			v := "1001110";
		elsif t = "1101" then
			v := "0111101";
		elsif t = "1110" then
			v := "1001111";
		elsif t = "1111" then
			v := "1000111";
		end if;
		--if ssd_value(4) = '1' then
			--ssd_controls <= (others => '0');
		--else
		ssd_controls <= v & ssd_value(4);
		--end if;
	end process;

	ssd_sync: process (clk, rst)
	begin
		if rst = '1' then
			r_clock_div <= (others => '0');
			r_current_segment <= "00000001";
			r_data <= (others => '0');
		elsif rising_edge(clk) then
			r_clock_div <= clock_div;
			r_current_segment <= current_segment;
			r_data <= data_next;
		end if;
	end process;

	clock_div <= std_logic_vector(unsigned(r_clock_div) + 1);

	current_segment <= r_current_segment(0) & r_current_segment(7 downto 1) when to_integer(unsigned(r_clock_div)) = 0 else r_current_segment;
	data_next <= ssd_data when to_integer(unsigned(r_clock_div)) = 0 else r_data;

	annodes <= not (ssd_enable and r_current_segment);

	cathodes <= not ssd_controls;

	sval: process (r_data, r_current_segment)
	begin
		ssd_value <= (others => '0');
		for i in 0 to 7 loop
			if r_current_segment(i) = '1' then
				if i = 7 then
					ssd_value <= '1' & r_data(i*4+3 downto i*4);
				elsif i = 3 then
					ssd_value <= '1' & r_data(i*4+3 downto i*4);
				else
					ssd_value <= '0' & r_data(i*4+3 downto i*4);
				end if;
			end if;
		end loop;
	end process;

	ssd_enable <= "10111011";

	rf_w_en <= buttons(0); -- left

	regfile: entity work.register_file
	generic map (
		word_size => rf_word_size,
		size => rf_size
	)
	port map (
		addr_a => rf_addr_a,
		addr_b => rf_addr_b,
		addr_c => rf_addr_c,
		data_a => rf_data_a,
		data_b => rf_data_b,
		data_c => rf_data_c,
		w_en   => rf_w_en,
		clk    => clk
	);

	rf_addr_a <= switches(15 downto 12);
	rf_addr_b <= switches(11 downto 8);
	rf_addr_c <= switches(11 downto 8);
	rf_data_c <= switches(7 downto 0);

	ssd_data(31 downto 28) <= switches(15 downto 12); -- addr A
	ssd_data(27 downto 24) <= (others => '0'); -- off
	ssd_data(23 downto 16) <= rf_data_a; -- data A
	ssd_data(15 downto 12) <= switches(11 downto 8); -- addr B
	ssd_data(11 downto 8) <= (others => '0'); -- off
	ssd_data(7 downto 0) <= rf_data_b; -- data B

end behav;


