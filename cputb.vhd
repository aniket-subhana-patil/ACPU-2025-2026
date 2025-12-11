----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.12.2025 17:04:17
-- Design Name: 
-- Module Name: cputb - Behavioral
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

entity cputb is
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

end cputb;

architecture Behavioral of cputb is

    signal rst : std_logic :='0';
    signal clk : std_logic := '0';
    signal clk_inst_mem: std_logic :='0';
    signal inst_mem_data_in:   std_logic_vector(bits-1 downto 0):=(others=>'0');
    signal inst_mem_addr_in:   std_logic_vector(log2(inst_mem_size)-1 downto 0):=(others=>'0');
    signal inst_write:  std_logic:='0';
    signal debug:  std_logic_vector(bits-1 downto 0):=(others=>'0');
    signal f_zero_debug :  std_logic:='0';
                
    signal f_ltzero_debug :  std_logic:='0';
    signal f_slt_debug:  std_logic:='0';
        signal jump_debug:  std_logic:='0';

    signal branch_debug:  std_logic:='0';

    signal pc_out_debug: std_logic_vector(bits-1 downto 0):=(others=>'0');
    signal control_debug: std_logic_vector(bits-1 downto 0):=(others=>'0');
    signal pc_in_debug:  std_logic_vector(bits-1 downto 0);

begin




    CPU : entity work.singlecyclecpu(Behavioral)
        port map(
            clk=>clk,
            rst=>rst,
            inst_mem_data_in=>inst_mem_data_in,
            inst_mem_addr_in=>inst_mem_addr_in,
            inst_write=>inst_write,
            debug=>debug,
            f_zero_debug=>f_zero_debug,
            f_ltzero_debug=>f_ltzero_debug,
            f_slt_debug=>f_slt_debug,
            clk_inst_mem=>clk_inst_mem,
            pc_out_debug=>pc_out_debug,
            branch_debug=>branch_debug,
            jump_debug=>jump_debug,
            pc_in_debug=>  pc_in_debug

        );
        	sim: process
	begin
    clk_inst_mem<='0';
    wait for 5ns;
    inst_mem_addr_in<="0000000";
    inst_mem_data_in<=x"00330313";
    clk_inst_mem <= '1';
    inst_write<='1';
    wait for 5ns;
    inst_write<='0';
    clk_inst_mem<='0'; 
    wait for 5ns;
    inst_mem_addr_in<="0000100";
    inst_mem_data_in<=x"00438393";
    clk_inst_mem <= '1';
    inst_write<='1';
    wait for 5ns;
    inst_write<='0';
    clk_inst_mem<='0'; 
    rst<='1';
    wait for 5ns;
    inst_mem_addr_in<="0001010";
    inst_mem_data_in<=x"00638eb3";
        rst<='0';

    clk_inst_mem <= '1';
    inst_write<='1';
    clk<='1' ;
    wait for 15ns;
    clk<='0';
    wait for 15ns;
    clk<='1' ;
    wait for 15ns;
    clk<='0';
    wait for 15ns;
        clk<='1' ;
    wait for 15ns;
    clk<='0';
    wait for 15ns;
    wait;
    end process;
    

end Behavioral;
