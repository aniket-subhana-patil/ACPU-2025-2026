----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.11.2025 15:07:29
-- Design Name: 
-- Module Name: cpuwrapper - Behavioral
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

entity cpuwrapper is
--  Port ( );
generic(
    bits: integer:=32;
    inst_mem_size: integer:=128;
    inst_word_size: integer:= 32;
    data_mem_size: integer:=256;
    data_word_size: integer:= 32;
    reg_file_mem_size: integer:=32;
    reg_file_word_size: integer:= 32
);

end cpuwrapper;

architecture Behavioral of cpuwrapper is
   signal clk:  std_logic;
  signal  rst:  std_logic;
   signal   inst_mem_data_in:   std_logic_vector(bits-1 downto 0);
  signal  inst_mem_addr_in:   std_logic_vector(log2(inst_mem_size)-1 downto 0);
 signal   inst_mem_data_out:   std_logic_vector(bits-1 downto 0);
 signal   reg_file_data_a:  std_logic_vector(bits-1 downto 0);
signal    reg_file_data_b:  std_logic_vector(bits-1 downto 0);
signal    reg_file_data_c:  std_logic_vector(bits-1 downto 0);
 signal   pc_debug:  std_logic_vector(bits-1 downto 0);
    
 signal   control_debug:  std_logic_vector(bits-1 downto 0);


   signal     alu_out_debug:   std_logic_vector(bits-1 downto 0);
    signal inst_write:  std_logic;
        signal f_zero_debug,f_ltzero_debug,f_slt_debug: std_logic:='0';

--  signal  debug:  std_logic_vector(31 downto 0);
 begin
    cpu: entity work.singlecyclecpu
    generic map(
        bits =>bits,
    inst_mem_size=> inst_mem_size,
    inst_word_size=> inst_word_size,
    data_mem_size=> data_mem_size,
    data_word_size=>     data_word_size,
    reg_file_mem_size=> reg_file_mem_size,
    reg_file_word_size=> reg_file_word_size
  
    )
    port map(
    clk=>clk,
    rst=>rst,
    inst_mem_data_in=>inst_mem_data_in,
    inst_mem_addr_in=> inst_mem_addr_in,
    inst_write=>inst_write,
    debug=>control_debug,
f_zero_debug=>f_zero_debug,
f_ltzero_debug=>f_ltzero_debug,
f_slt_debug=>f_slt_debug
    );

end Behavioral;
