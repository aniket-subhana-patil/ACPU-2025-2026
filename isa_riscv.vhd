library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

package	isa_riscv is

	constant opcode_ADD : std_logic_vector(3 downto 0) := "0000";
	constant opcode_SUB : std_logic_vector(3 downto 0) := "1000";
	constant opcode_SLL : std_logic_vector(3 downto 0) := "0001";
	constant opcode_SLT : std_logic_vector(3 downto 0) := "0010";
	constant opcode_SLTU: std_logic_vector(3 downto 0) := "0011";
	constant opcode_XOR : std_logic_vector(3 downto 0) := "0100";
	constant opcode_SRL : std_logic_vector(3 downto 0) := "0101";
	constant opcode_SRA : std_logic_vector(3 downto 0) := "1101";
	constant opcode_OR  : std_logic_vector(3 downto 0) := "0110";
	constant opcode_AND : std_logic_vector(3 downto 0) := "0111";

end isa_riscv;

package body isa_riscv is 

end isa_riscv;
