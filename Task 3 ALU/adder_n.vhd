library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity adder_n is

	-------------------------------
	-- TODO
	-- Define Ports and generics
	-------------------------------
    generic(
        bits: integer:=32
    );
    port(
        a:in std_logic_vector(bits-1 downto 0);
        b: in std_logic_vector(bits-1 downto 0);
        c: out std_logic_vector(bits-1 downto 0)
    );
end entity adder_n;

architecture behav of adder_n is

	-------------------------------
	-- TODO (if required)
	-- Define additional signals
	-------------------------------

begin

	-------------------------------
	-- TODO
	-- Define adder behavior
	-------------------------------
    c<= std_logic_vector(signed(a) + signed(b));
end behav;

