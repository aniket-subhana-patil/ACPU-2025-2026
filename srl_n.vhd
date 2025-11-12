    ----------------------------------------------------------------------------------
    -- Company: 
    -- Engineer: 
    -- 
    -- Create Date: 12.11.2025 22:39:11
    -- Design Name: 
    -- Module Name: srl_n - Behavioral
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

    -- Uncomment the following library declaration if using
    -- arithmetic functions with Signed or Unsigned values
    --use IEEE.NUMERIC_STD.ALL;
    
    -- Uncomment the following library declaration if instantiating
    -- any Xilinx leaf cells in this code.
    --library UNISIM;
    --use UNISIM.VComponents.all;
    
    entity srl_n is
                generic(bits: integer:=32);
            port(
                    a: in std_logic_vector(bits-1 downto 0);
                    b: in std_logic_vector(bits-1 downto 0);
                    c: out std_logic_vector(bits-1 downto 0)
                    );
end srl_n;
    
    architecture Behavioral of srl_n is
    
    begin
        process(a, b)
            variable temp : std_logic_vector(a'range);
            variable shift_amt : integer;
        begin
            shift_amt := to_integer(unsigned(b));
            temp := (others => a(bits-1));
        
            if shift_amt < a'length then
                temp(a'length-1 downto shift_amt) := a(a'length-1 downto shift_amt);
                
            end if;
        
            c <= temp;
        end process;

    end Behavioral;
