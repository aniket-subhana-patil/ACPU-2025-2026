----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.11.2025 13:59:15
-- Design Name: 
-- Module Name: andn - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity and_n is
--  Port ( );
    generic(
        bits: integer:=32
    );
    port(
        a:in std_logic_vector(bits-1 downto 0);
        b: in std_logic_vector(bits-1 downto 0);
        c: out std_logic_vector(bits-1 downto 0)
    );
end and_n;

architecture Behavioral of and_n is

begin
        c<= a and b;


end Behavioral;
