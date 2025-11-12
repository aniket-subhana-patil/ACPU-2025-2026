----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.11.2025 19:22:03
-- Design Name: 
-- Module Name: slt_n - Behavioral
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

entity slt_n is
    generic(
        bits: integer:=32
    );
    port(
        a:in std_logic_vector(bits-1 downto 0);
        b: in std_logic_vector(bits-1 downto 0);
        f_slt: out std_logic
    );
end slt_n;

architecture Behavioral of slt_n is

--        f_slt<= '1 when a(bits-1) ='1' and b(bits-1) ='0' ;
        
begin
        

end Behavioral;
