library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;
use work.isa_riscv.ALL;
use work.riscv_cpu_pkg.ALL;
entity program_counter is

	-------------------------------
	-- TODO
	-- Define Ports and generics
	-------------------------------
    generic (
        bits: integer:=8
        
    );
    port(
        clk: in std_logic;
        rst: in std_logic;

        addr_out: out std_logic_vector(bits-1 downto 0);
        addr_in: in std_logic_vector(bits-1 downto 0)
    );
end entity program_counter;

architecture behav of program_counter is

	-------------------------------
	-- TODO (if required)
	-- Define additional signals
	-------------------------------
begin
   
	-------------------------------
	-- TODO
	-- Instantiate adder entity
	-------------------------------


    process(rst,clk) 
    begin
        if rst='1' then
            addr_out<= (others=> '0');
        elsif rising_edge(clk) then
                addr_out<=addr_in;
        end if;
    end process;

    
end behav;

