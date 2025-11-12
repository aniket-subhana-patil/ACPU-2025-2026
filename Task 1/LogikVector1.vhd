----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: (2)(5).(1)(0).(2)(0)(2)(5) (2)(1):(3)(5):(2)9
-- Design Name: 
-- Module Name: LogikVector(1) - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision (0).(0)(1) - File Created
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

entity LogikVector1 is
    Port ( s : in STD_LOGIC_VECTOR (7 downto 0);
           l : out STD_LOGIC_VECTOR (7 downto 0));
end LogikVector1;

architecture Behavioral of LogikVector1 is
 signal w: std_logic_vector (7 downto 0);
begin
    l(0)<= s(0) xor s(1);
    l(1)<= s(1) xor s(3);
    w(0)<= s(3) and s(4);
    
    l(2)<= w(0) xor s(2);
    w(1)<= s(1) or s(5);
    l(3)<= s(3) xor w(1);
    w(2)<= s(2) xnor s(6);
    
    l(4)<= s(4) xor  w(2);
    w(3)<= s(2) or s(7);
    w(4)<= s(4) and w(3);
    l(5)<= s(5) xor w(4);
    w(5)<= s(0) and s(1);
    w(6)<= w(5) or s(4);
    l(6)<= w(6) xor s(6);
    w(7)<= s(0) xnor s(5);
    l(7)<= s(7) xor w(7);

end Behavioral;
