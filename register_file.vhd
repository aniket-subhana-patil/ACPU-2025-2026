    ----------------------------------------------------------------------------------
    -- Company: 
    -- Engineer: 
    -- 
    -- Create Date: 13.11.2025 13:32:08
    -- Design Name: 
    -- Module Name: reg_file - Behavioral
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
    use IEEE.numeric_std.ALL;
    
    -- Uncomment the following library declaration if using
    -- arithmetic functions with Signed or Unsigned values
    --use IEEE.NUMERIC_STD.ALL;
    
    -- Uncomment the following library declaration if instantiating
    -- any Xilinx leaf cells in this code.
    --library UNISIM;
    --use UNISIM.VComponents.all;
    
    entity register_file is
        generic(
         size : integer := 8;
         word_size : integer := 32
        );
        port(
        addr_a : in std_logic_vector(log2(size)-1 downto 0);
        addr_b : in std_logic_vector(log2(size)-1 downto 0);
        addr_c : in std_logic_vector(log2(size)-1 downto 0);
        data_c : in  std_logic_vector(word_size-1 downto 0);
        data_a : out  std_logic_vector(word_size-1 downto 0);
        data_b : out  std_logic_vector(word_size-1 downto 0);
        clk, w_en : in  std_logic
         
         
    );
    
    end register_file;
    architecture Behavioral of register_file is
        type reg_array_t is array (0 to size-1) of std_logic_vector(word_size-1 downto 0);
        shared variable regs: reg_array_t:=(others => (others => '0'));
    begin
        process(clk,w_en,addr_c) begin
            if rising_edge(clk) and w_en ='1' then
                regs(TO_INTEGER( unsigned(addr_c))):= data_c;
            end if;
        end process;
        process(clk,addr_b) begin
            if rising_edge(clk) then
                data_b <=regs(TO_INTEGER( unsigned(addr_b)));
            end if;
        end process;
        process(clk,addr_a) begin
            if rising_edge(clk) then
                data_a <=regs(TO_INTEGER( unsigned(addr_a)));
            end if;
        end process;
    end Behavioral;
