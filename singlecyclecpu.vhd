----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/27/2025 11:51:00 AM
-- Design Name: 
-- Module Name: singlecyclecpu - Behavioral
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

entity singlecyclecpu is
--  Port ( );
generic(
    bits: integer:=32;
    mem_size: integer:=128;
    word_size: integer:= 32

);
end singlecyclecpu;

architecture Behavioral of singlecyclecpu is
    signal pc_in,inst_mem_out: std_logic_vector(bits-1 downto 0);
    signal mem_reg_a, mem_reg_b: std_logic_vector(bits-1 downto 0);
    signal alu_out: std_logic_vector(bits-1 downto 0);
    signal f_zero,f_ltzero,f_slt: std_logic;
    signal pc_out: std_logic_vector(bits-1 downto 0):= (others=>'0');
begin

    program_counter : entity work.program_counter
    generic map(
        bits=> bits
    )
    port map(
        a=>pc_in,c=> pc_out
    );
        inst_memory : entity work.memory
    generic map(
        mem_size=>mem_size,word_size=> word_size
    )
    port map(
        addr_read=>pc_out,
        data_read=> inst_mem_out,
        addr_write=> (others=>'0'),
        data_write=>(others=>'0'),
        write_en=>'0',read_en=>'0',clk=>'0'
    );
    reg_file:entity work.register_file
    port map(
        addr_a=> inst_mem_out(19 downto 15),
        addr_b=> inst_mem_out(24 downto 20),
        addr_c=> inst_mem_out(11 downto 7),
        data_a=> mem_reg_a,
        data_b=> mem_reg_b,
        data_c=> (others=>'0'),
        write_en => '0'
    );
    alu: entity work.alu
    port map(
        a=> mem_reg_a,
        b=> mem_reg_b,
        c=> alu_out
    )
    

end Behavioral;
