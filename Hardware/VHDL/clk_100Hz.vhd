----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.12.2023 14:58:06
-- Design Name: 
-- Module Name: clk_100Hz - Behavioral
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
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clk_100Hz is
    Port ( clk, rst :in std_logic;
    clk100Hz: out std_logic);
end clk_100Hz;

architecture archi of clk_100Hz is

signal clk_100 : std_logic_vector(19 downto 0);

begin
    process (rst, clk)
    variable cnt: std_logic_vector (19 downto 0);
    begin
        if rst ='1' then cnt:= (others => '0');
        elsif clk'event and clk ='1' then
            cnt := cnt + 1;
            clk_100 <= cnt;
        end if;
    end process;
    
    clk100Hz <= clk_100(19);
end archi;