library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

use work.misc.ALL;

entity register_file_tb is
end entity register_file_tb;

architecture behav of register_file_tb is

	constant size : integer := 8;
	constant word : integer := 32;

	signal addr_a, addr_b, addr_c : std_logic_vector(log2(size)-1 downto 0);
	signal data_a, data_b, data_c : std_logic_vector(word-1 downto 0);
	signal clk, write : std_logic;

begin

	vc: process
	begin
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
	end process;

	uut: entity work.register_file
	generic map(word_size => word, size => size)
	port map(addr_a => addr_a, addr_b => addr_b, addr_c => addr_c, data_a => data_a, data_b => data_b, data_c => data_c, w_en => write, clk => clk);

	sim: process
		variable x : integer := 1;
		variable y : integer := 1;
		variable z : integer;
	begin
		addr_a <= (others => '0');
		addr_b <= (others => '1');
		addr_c <= (others => '0');
		data_c <= (others => '0');
		write <= '0';
		wait for 20 ns;
		write <= '1';
	 	for i in 0 to size-1 loop
			addr_c <= std_logic_vector(to_unsigned(i, addr_c'length));
			if i = 0 then
				data_c <= std_logic_vector(to_signed(x, data_c'length));
			elsif i = 1 then
				data_c <= std_logic_vector(to_signed(y, data_c'length));
			else
				z := x + y;
				data_c <= std_logic_vector(to_signed(z, data_c'length));
				x := y;
				y := z;
			end if;
			wait for 20 ns;
	 	end loop;
		write <= '0';
	 	for i in 0 to size-1 loop
			addr_a <= std_logic_vector(to_unsigned(i, addr_a'length));
			addr_b <= std_logic_vector(to_unsigned(size-i-1, addr_a'length));
			wait for 20 ns;
	 	end loop;
		wait;
	end process;

end behav;

