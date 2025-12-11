library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

package	riscv_cpu_pkg is

	pure function log2 (N : positive) return natural;
end riscv_cpu_pkg;

package body riscv_cpu_pkg is 
pure function log2 (N : positive) return natural is
    variable result : natural := 0;
    variable temp   : natural := N - 1; -- N-1 gives the largest value to encode
  begin
    while temp > 0 loop
      temp := temp / 2;
      result := result + 1;
    end loop;
    return result;
  end function log2;
end riscv_cpu_pkg;
