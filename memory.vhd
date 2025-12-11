library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;
use work.isa_riscv.ALL;
use work.riscv_cpu_pkg.ALL;
-- TODO include your package

entity memory is 
	generic (
		-- TODO declare generics word_size and mem_size
		word_size : integer := 32;
		mem_size  : integer := 128
	);
	port (
	
	     addr_read  : in std_logic_vector(log2(mem_size)-1 downto 0);
		 addr_write : in std_logic_vector(log2(mem_size)-1 downto 0);
		 data_read  : out std_logic_vector(word_size-1 downto 0);
		 data_write : in std_logic_vector(word_size-1 downto 0);
		 write_en   : in std_logic;
		 read_en    : in std_logic;
		 clk        : in std_logic
		-- TODO declare ports addr_write, addr_read, data_write, data_read, writen_en, read_en, clk
	);
end entity memory;

architecture behav of memory is

	-- TODO declare types and signals
    type mem is array(mem_size-1 downto 0) of std_logic_vector(word_size-1 downto 0);
    shared variable int_mem : mem:=(others=>(others=>'0'));
begin
 
	-- TODO add implementation
    process(clk,addr_read,read_en) begin
        if rising_edge(clk) and read_en ='1' then
            data_read<= int_mem(TO_INTEGER(unsigned(addr_read)));
            end if;
    end process;
    process(clk,addr_write,write_en) begin
        if rising_edge(clk) and write_en ='1' then
            int_mem(TO_INTEGER(unsigned(addr_write))):= data_write ;
            end if;
    end process;
    
end behav;


