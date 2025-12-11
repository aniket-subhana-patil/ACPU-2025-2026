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
use work.isa_riscv.ALL;
use work.riscv_cpu_pkg.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
use IEEE.numeric_std.ALL;

entity sltu_n is
    generic(
        bits: integer:=32
    );
    port(
        a:in std_logic_vector(bits-1 downto 0);
        b: in std_logic_vector(bits-1 downto 0);
        c: out std_logic_vector(bits-1 downto 0)
    );
end sltu_n;

architecture Behavioral of sltu_n is
        
begin
    process(a,b) begin
    if unsigned(a) < unsigned(b) then
      c <= (others => '0');
      c(0) <= '1';
    else
      c <= (others => '0');
    end if;
    end process;
end Behavioral;
