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
use IEEE.numeric_std.ALL;

use work.isa_riscv.ALL;
use work.riscv_cpu_pkg.ALL;
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
    inst_mem_size: integer:=128;
    inst_word_size: integer:= 32;
    data_mem_size: integer:=256;
    data_word_size: integer:= 32;
    reg_file_mem_size: integer:=32;
    reg_file_word_size: integer:= 32
);
    port(
    clk: in std_logic;
    clk_inst_mem: in std_logic;
    rst: in std_logic;
    inst_mem_data_in:  in std_logic_vector(bits-1 downto 0);
    inst_mem_addr_in:  in std_logic_vector(log2(inst_mem_size)-1 downto 0);
    inst_write: in std_logic;
    debug: out std_logic_vector(bits-1 downto 0);
                f_zero_debug : out std_logic;
                
                f_ltzero_debug : out std_logic;
                f_slt_debug: out std_logic;
    pc_out_debug: out std_logic_vector(bits-1 downto 0);
        pc_in_debug: out std_logic_vector(bits-1 downto 0);

    branch_debug: out std_logic;
        jump_debug: out std_logic

);

end singlecyclecpu;

architecture Behavioral of singlecyclecpu is
    signal pc_in : std_logic_vector(bits-1 downto 0):=(others=>'0');
    signal inst_mem_out: std_logic_vector(bits-1 downto 0):=(others=>'0');
    signal mem_reg_a, mem_reg_b,mem_reg_c: std_logic_vector(bits-1 downto 0):=(others=>'0');
    signal reg_bank_data_c,alu_port_b,alu_port_a: std_logic_vector(bits-1 downto 0):=(others=>'0');
    signal extended_imm: std_logic_vector(bits-1 downto 0):=(others=>'0');
    signal op_code: std_logic_vector(3 downto 0):=(others=>'0');
    signal alu_out: std_logic_vector(bits-1 downto 0):=(others=>'0');
    signal f_zero,f_ltzero,f_slt,f_sltu,f_zerou: std_logic:='0';
    signal pc_out: std_logic_vector(bits-1 downto 0):=(OTHERS=>'0');
    signal  reg_write:  std_logic:='0';
    signal alu_src:  std_logic:='0';
    signal   mem_read:  std_logic:='0';
    signal   mem_write:  std_logic:='0';
    signal  branch:  std_logic:='0';
    signal mem_to_reg: std_logic:='0';
    signal jump,pc_to_reg,alu_src_a: std_logic:='0';
    signal imm_in:  std_logic_vector(bits-1 downto 0);
attribute mark_debug : string;

attribute mark_debug of reg_write   : signal is "true";
attribute mark_debug of mem_write   : signal is "true";
attribute mark_debug of mem_read    : signal is "true";
attribute mark_debug of branch      : signal is "true";
attribute mark_debug of jump        : signal is "true";
attribute mark_debug of alu_src     : signal is "true";
attribute mark_debug of alu_src_a   : signal is "true";
attribute mark_debug of pc_to_reg   : signal is "true";
attribute mark_debug of op_code     : signal is "true";
attribute mark_debug of extended_imm: signal is "true";
begin

--    imm_in<= alu_out when jump='1' or(f_zero='1' and branch='1' ) else pc_out;

    pc_in <= alu_out when jump='1' else
         std_logic_vector(signed(pc_out) + signed(extended_imm)) when (branch='1' and f_zero='1') else
         std_logic_vector(signed(pc_out) + 4);    
         
    program_counter : entity work.program_counter
    generic map(
        bits=> bits
    )
    port map(
        addr_in=>pc_in,
        addr_out=> pc_out,
        rst=>rst,
        clk=>clk
        
    );
    pc_in_debug<=pc_in;
        pc_out_debug<=pc_out;

        inst_memory : entity work.memory
    generic map(
        mem_size=>inst_mem_size,word_size=> inst_word_size
    )
    port map(
        addr_read=>pc_out(6 downto 0),
        data_read=> inst_mem_out,
        addr_write=>inst_mem_addr_in,
        data_write=>inst_mem_data_in,
        write_en=>inst_write,
        read_en=>'1',
        clk=>clk_inst_mem
    );
    mem_reg_c<= pc_out when pc_to_reg='1' else  reg_bank_data_c when mem_to_reg='1' else alu_out;
    reg_file:entity work.register_file
    generic map(
        word_size=>reg_file_word_size,
        size=>reg_file_mem_size
    )
    port map(
        addr_a=> inst_mem_out(19 downto 15),
        addr_b=> inst_mem_out(24 downto 20),
        addr_c=> inst_mem_out(11 downto 7),
        data_a=> mem_reg_a,
        data_b=> mem_reg_b,
        data_c=> mem_reg_c,
        w_en =>reg_write ,
        clk=>clk
    );
    alu_port_b<= extended_imm  when alu_src='1' else  mem_reg_b;
    alu_port_a<= pc_out  when alu_src_a ='1' else  mem_reg_a;
    control_logic : entity work.control_logic
    port map(
        control_deciding_connections=> inst_mem_out,
        extended_values=> extended_imm,
        op_code=>op_code,
        reg_write=>reg_write,
        alu_src=>alu_src,
        mem_read=>mem_read,
        mem_write=>mem_write,
        branch=>branch,
        mem_to_reg=>mem_to_reg,
        jump=> jump,
        alu_src_a=>alu_src_a,
        pc_to_reg=>pc_to_reg,
        f_zero=>f_zero ,
        f_slt=>f_slt ,
        f_sltu=>f_sltu,
        f_zerou=>f_zerou
    );
    branch_debug<=branch;
    jump_debug<=jump;

    alu: entity work.alu
    port map(
        a=> alu_port_a,
        b=> alu_port_b,
        c=> alu_out,
        op=> op_code,
        f_zero=>f_zero,
        f_ltzero=>f_ltzero,
        f_slt=>f_slt,
        f_sltu=>f_sltu,
        f_zerou=>f_zerou
    );
    f_zero_debug<= f_zero;
    f_ltzero_debug<=f_ltzero;
    f_slt_debug<=f_slt;
    data_mem: entity work.memory
    generic map(
        mem_size=>data_mem_size,word_size=> data_word_size
    )
    port map(
        addr_read=> alu_out(7 downto 0),
        addr_write=> alu_out(7 downto 0),
        data_write=> mem_reg_b,
        data_read=> reg_bank_data_c,
        write_en =>mem_write,
        read_en=>mem_read,
        clk=>clk
    );
    debug<=alu_out;

end Behavioral;