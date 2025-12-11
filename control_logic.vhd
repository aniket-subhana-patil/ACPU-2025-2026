----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.11.2025 15:52:06
-- Design Name: 
-- Module Name: control_logic - Behavioral
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

entity control_logic is
--  Port ( );
    generic(
        bits: integer:=32
    );
        port(
    control_deciding_connections: in std_logic_vector(bits-1 downto 0);
    
    
    op_code: out std_logic_vector(3 downto 0);
    reg_write: out std_logic;
    alu_src: out std_logic;
    mem_read: out std_logic;
    mem_write: out std_logic;
    branch: out std_logic;
    jump: out std_logic;
    mem_to_reg: out std_logic;
    pc_to_reg: out std_logic;
    alu_src_a: out std_logic;
    f_zero: in std_logic;
    f_slt: in std_logic;
    f_sltu: in std_logic;
    f_zerou: in std_logic;

    extended_values: out std_logic_vector(bits-1 downto 0)
);
end control_logic;

architecture Behavioral of control_logic is

begin
   control_logic:  process(control_deciding_connections,f_zero,f_slt,f_sltu,f_zerou) begin
        op_code<="0000";
        reg_write<='0';
        alu_src<='0';
        mem_read<='0';
        mem_write<='0';
        branch<='0';
        mem_to_reg<='0';
        pc_to_reg<='0';
        alu_src_a<='0';
        jump<='0';
        extended_values<=(others=>'0');
         if(control_deciding_connections(6 downto 0) = op_OP) then
            op_code <= control_deciding_connections(30) & control_deciding_connections(14 downto 12);
            reg_write <='1';
          elsif (control_deciding_connections(6 downto 0) =op_IMM) then
            if control_deciding_connections(8 downto 7)="01" then
                op_code<= control_deciding_connections(30) & control_deciding_connections(14 downto 12);
                extended_values(bits-1 downto 5)<= (others=>control_deciding_connections(31));
                extended_values(4 downto 0)<= control_deciding_connections(24 downto 20);
            else
                extended_values(bits-1 downto 12)<= (others=>control_deciding_connections(31));
                extended_values(11 downto 0)<= control_deciding_connections(31 downto 20);
                op_code<='0' & control_deciding_connections(14 downto 12);
                
            end if;

            alu_src<='1';
            reg_write<='1';
            --store 
          elsif (control_deciding_connections(6 downto 0)=op_STORE)then
                op_code<= '0'& control_deciding_connections(14 downto 12);
                mem_write<='1';
                alu_src<='1';
                extended_values(bits-1 downto 10)<= (others=>control_deciding_connections(31));
                extended_values(11 downto 5)<= control_deciding_connections(31 downto 25);
                extended_values(4 downto 0)<= control_deciding_connections(11 downto 7);

           --load
          elsif (control_deciding_connections(6 downto 0)=op_LOAD) then
                op_code<=opcode_ADD;
                mem_read<='1';
                mem_to_reg<='1';
                extended_values(bits-1 downto 12)<= (others=>control_deciding_connections(31));
                extended_values(11 downto 0)<= control_deciding_connections(31 downto 20);

            --branch
          elsif (control_deciding_connections(6 downto 0)=op_BRANCH)then
--                op_code<= '0'& control_deciding_connections(9 downto 7);
                op_code<= opcode_SUB;
                extended_values(0)<='0';
                extended_values(12)<= control_deciding_connections(31);
                extended_values(11)<= control_deciding_connections(8);
                extended_values(10 downto 5)<= control_deciding_connections(30 downto 25);
                extended_values(4 downto 1)<= control_deciding_connections(11 downto 8);
                extended_values(31 downto 13)<= (others=>'0');
                if(control_deciding_connections(14 downto 12)=func_BEQ) then
                    branch<= f_zero;
                elsif (control_deciding_connections(14 downto 12)=func_BEQ) then
                    branch<= not f_zero;
                elsif (control_deciding_connections(14 downto 12)=func_BEQ) then
                    branch<= f_slt;
                elsif (control_deciding_connections(14 downto 12)=func_BEQ) then
                    branch<= (not f_slt) or f_zero;
                elsif (control_deciding_connections(14 downto 12)=func_BEQ) then
                    branch<= f_sltu;
                    
                elsif (control_deciding_connections(14 downto 12)=func_BEQ) then
                    branch<=(not f_sltu) or f_zerou;
                else
                    branch<='0';
                end if;
                
           --jalr
          elsif (control_deciding_connections(6 downto 0)=op_JALR)then
                op_code<=opcode_ADD;
                jump<='1';
                reg_write<='1';
                pc_to_reg<='1';
                extended_values(bits-1 downto 12)<= (others=>control_deciding_connections(31));
                extended_values(11 downto 0)<=control_deciding_connections(31 downto 20);
           --jal
          elsif (control_deciding_connections(6 downto 0)=op_JAL)then
                op_code<=opcode_ADD;
                jump<='1';
                reg_write<='1';
                alu_src_a<='1';
                pc_to_reg<='1';

                extended_values(bits-1 downto 21)<= (others=>control_deciding_connections(31));
                extended_values(20)<=control_deciding_connections(31);
                  extended_values(19 downto 12)<=control_deciding_connections(19 downto 12);
                  extended_values(11)<=control_deciding_connections(20);
                  extended_values(10  downto 1)<= control_deciding_connections(30 downto 21);
                  extended_values(0)<='0';
          elsif (control_deciding_connections(6 downto 0)=op_AUIPC)then
                op_code<=opcode_ADD;
                alu_src_a<='1';
                extended_values(11 downto 0)<=(others=>'0');
                extended_values(bits-1 downto 12)<=control_deciding_connections(31 downto 12);
                reg_write<='1';
          else
                  op_code<="0000";
        reg_write<='0';
        alu_src<='0';
        mem_read<='0';
        mem_write<='0';
        branch<='0';
        mem_to_reg<='0';
        pc_to_reg<='0';
        alu_src_a<='0';
        jump<='0';
          
          end if;  
          
    end process;

end Behavioral;
