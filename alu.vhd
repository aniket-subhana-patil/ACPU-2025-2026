            library IEEE;
        use IEEE.std_logic_1164.ALL;
        use IEEE.numeric_std.ALL;
        use work.isa_riscv.ALL;
use work.riscv_cpu_pkg.ALL;
        
        entity alu is
        
            -------------------------------
            -- TODO
            -- Define Ports and generics
            -------------------------------
            generic(
                bits: integer:=32
            );
                port(
                a:in std_logic_vector(bits-1 downto 0);
                b: in std_logic_vector(bits-1 downto 0);
                op : in  std_logic_vector(3 downto 0);
                c: out std_logic_vector(bits-1 downto 0);
                f_zero : out std_logic;
                f_zerou : out std_logic;
                f_ltzero : out std_logic;
                f_slt: out std_logic;
                f_sltu:out std_logic
                
            );
        end entity alu;
        
        architecture behav of alu is

            -------------------------------
            -- TODO (if required)
            -- Define additional signals
            -------------------------------
            signal c_and, c_or, c_xor, c_add, c_sub,c_subu: std_logic_vector(bits-1 downto 0); -- NEW SIGNALS
            signal c_sll,c_srl,c_sra,c_slt,c_sltu,c_final: std_logic_vector(bits-1 downto 0);
--            attribute mark_debug : string;

--                    attribute mark_debug of c_and   : signal is "true";
--attribute mark_debug of c_or   : signal is "true";
--attribute mark_debug of c_xor    : signal is "true";
--attribute mark_debug of c_add      : signal is "true";
--attribute mark_debug of c_sub        : signal is "true";
--attribute mark_debug of c_sll     : signal is "true";
--attribute mark_debug of c_srl   : signal is "true";
--attribute mark_debug of c_sra   : signal is "true";
--attribute mark_debug of c_slt     : signal is "true";
--attribute mark_debug of c_sltu: signal is "true";
        begin

            c_and <= a and b;
            c_or  <= a or b;
            c_xor <= a xor b;
        
            -- Arithmetic Operations (Implemented with VHDL Operators and NUMERIC_STD)
            c_add <= std_logic_vector( signed(a) + signed(b) );
            c_sub <= std_logic_vector( signed(a) - signed(b) );
            c_subu <= std_logic_vector(  unsigned(a) - unsigned(b));
            sll_n: entity work.sll_n
            generic map(bits)
            port map(a=>a,b=>b,c=>c_sll);
            srl_n: entity work.srl_n
            generic map(bits)
            port map(a=>a,b=>b,c=>c_srl);
            sra_n: entity work.sra_n
            generic map(bits)
            port map(a=>a,b=>b,c=>c_sra);
            slt_n: entity work.slt_n
            generic map(bits)
            port map(a=>a,b=>b,c=>c_slt);
            sltu_n: entity work.sltu_n
            generic map(bits)
            port map(a=>a,b=>b,c=>c_sltu);

with op select
    c_final <= c_and  when opcode_AND,
               c_or   when opcode_OR,
               c_xor  when opcode_XOR,
               c_add  when opcode_ADD,
               c_sub  when opcode_SUB,
               c_slt  when opcode_SLT,
               c_sltu when opcode_SLTU,
               c_sll  when opcode_SLL,
               c_srl  when opcode_SRL,
               c_sra  when opcode_SRA,
               (others=>'0') when others;



             c<=c_final;
             f_ltzero <= c_final(bits-1);
             f_slt <= c_slt(0);
             f_sltu <= c_sltu(0);

             
             f_zero <= '1' when c_final =x"00000000" else '0';
             f_zerou <= '1' when c_subu =x"00000000" else '0';

        end behav;
        
