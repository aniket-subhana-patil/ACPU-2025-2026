library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;
use work.misc.all;

entity register_file_timing_wrapper is
	generic (
		word_size : integer := 32;
		size 	  : integer := 32
	);
	port (
		addr_a : in  std_logic_vector(log2(size)-1 downto 0);
		addr_b : in  std_logic_vector(log2(size)-1 downto 0);
		addr_c : in  std_logic_vector(log2(size)-1 downto 0);
		data_a : out std_logic_vector(word_size-1 downto 0);
		data_b : out std_logic_vector(word_size-1 downto 0);
		data_c : in  std_logic_vector(word_size-1 downto 0);
		w_en   : in  std_logic;
		clk    : in  std_logic
	);
end entity register_file_timing_wrapper;

architecture behav of register_file_timing_wrapper is

	signal r_addr_a, r_addr_b, r_addr_c : std_logic_vector(log2(size)-1 downto 0);
	signal r_data_a, r_data_b, r_data_c : std_logic_vector(word_size-1 downto 0);
	signal r_w_en : std_logic;

begin

	rf: entity work.register_file
		generic map (
			word_size => word_size,
			size => size
		)
		port map (
			addr_a => r_addr_a,
			addr_b => r_addr_b,
			addr_c => r_addr_c,
			data_a => r_data_a,
			data_b => r_data_b,
			data_c => r_data_c,
			w_en => r_w_en,
			clk => clk
		);
	
	regs: process (clk)
	begin
		if rising_edge (clk) then
			r_addr_a <= addr_a;
			r_addr_b <= addr_b;
			r_addr_c <= addr_c;
			data_a <= r_data_a;
			data_b <= r_data_b;
			r_data_c <= data_c;
			r_w_en <= w_en;
		end if;
	end process;

end behav;


