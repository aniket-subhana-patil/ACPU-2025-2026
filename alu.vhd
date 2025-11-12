        library IEEE;
        use IEEE.std_logic_1164.ALL;
        use IEEE.numeric_std.ALL;
        
        use work.isa_riscv.ALL;
        
        entity alu is
        
            -------------------------------
            -- TODO
            -- Define Ports and generics
            -------------------------------
            generic(
                bits: integer:=32;
                zero: integer:=0
            );
                port(
                a:in std_logic_vector(bits-1 downto 0);
                b: in std_logic_vector(bits-1 downto 0);
                op : in  std_logic_vector(3 downto 0);
                c: out std_logic_vector(bits-1 downto 0);
                f_zero : out std_logic;
                
                f_ltzero : out std_logic;
                f_slt: out std_logic
            );
        end entity alu;
        
        architecture behav of alu is
        
            -------------------------------
            -- TODO (if required)
            -- Define additional signals
            -------------------------------
            signal c_and,c_or,c_xor,c_add,c_sub,c_sll,c_srl,c_sra,c_final: std_logic_vector(bits-1 downto 0) := (others=>'0');
            signal zero_temp: std_logic_vector(bits downto 0):=(others=>'0');
        begin
        
            -------------------------------
            -- TODO
            -- Define adder behavior
            -------------------------------
            and_n: entity work.and_n
            generic map(bits)
            port map(a,b,c_and);
            or_n: entity work.or_n
            generic map(bits)
            port map(a,b,c_or);
            xor_n: entity work.xor_n
            generic map(bits)
            port map(a,b,c_xor);
            adder_n:entity  work.adder_n
            generic map(bits)
            port map(a,b,c_add);
            sub_n: entity work.sub_n
            generic map(bits)
            port map(a,b,c_sub);
            sll_n: entity work.sll_n
            generic map(bits)
            port map(a,b,c_sll);
            srl_n: entity work.srl_n
            generic map(bits)
            port map(a,b,c_srl);
            sra_n: entity work.sra_n
            generic map(bits)
            port map(a,b,c_sra);
            c_final <= c_and when op = opcode_AND else
             c_or when op = opcode_OR  else
             c_xor when op = opcode_XOR else
             c_add when op =opcode_ADD else
             c_sub when op = opcode_SUB else
             c_sub when op= opcode_SLT else
             c_sll when op= opcode_SLL else
             c_srl when op= opcode_SRL else
                 c_sra when op= opcode_SRA else

             (others=>'0');
             
             c<=c_final;
             f_ltzero <= c_final(bits-1);
        
             f_zero <= zero_temp(bits);
    --         f_slt<= 1 when signed(a(bits-1)) 
             
              zero_checker: for i in 1 to bits-1 generate
                            zero_temp(i)<=zero_temp(i-1) nor c_final(i);
             
                   end  generate ; 
        end behav;
        
