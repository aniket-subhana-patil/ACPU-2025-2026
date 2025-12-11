    ----------------------------------------------------------------------------------
    -- Company: 
    -- Engineer: 
    -- 
    -- Create Date: 12.11.2025 22:44:29
    -- Design Name: 
    -- Module Name: sra_n - Behavioral
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
            use IEEE.NUMERIC_STD.ALL;
    use work.isa_riscv.ALL;
use work.riscv_cpu_pkg.ALL;
    -- Uncomment the following library declaration if using
    -- arithmetic functions with Signed or Unsigned values
    --use IEEE.NUMERIC_STD.ALL;
    
    -- Uncomment the following library declaration if instantiating
    -- any Xilinx leaf cells in this code.
    --library UNISIM;
    --use UNISIM.VComponents.all;
    
    entity sra_n is
                    generic(bits: integer:=32);
                port(
                        a: in std_logic_vector(bits-1 downto 0);
                        b: in std_logic_vector(bits-1 downto 0);
                        c: out std_logic_vector(bits-1 downto 0)
                        );
                        
    end sra_n;
    
    architecture Behavioral of sra_n is
                signal shift_input : unsigned(3 downto 0);
    begin
                   shift_input <= unsigned(b(3 downto 0));
               c <= std_logic_vector(shift_right(signed(a), to_integer(shift_input)));
                
    end Behavioral;
