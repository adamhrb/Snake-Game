library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  -- Use numeric_std instead of std_logic_unsigned

entity VGA_640_x_480 is
    Port ( rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           hsync : out  STD_LOGIC;
           vsync : out  STD_LOGIC;
           hc : out  STD_LOGIC_VECTOR (9 downto 0);
           vc : out  STD_LOGIC_VECTOR (9 downto 0);
           vidon : out  STD_LOGIC);
end VGA_640_x_480;

architecture Behavioral of VGA_640_x_480 is

constant hpixels:   unsigned(9 downto 0) := "1100100000"; -- nombre de pixels sur une ligne = 800
constant vlines:    unsigned(9 downto 0) := "1000001001"; -- nombre de lignes horizontales dans l'affichage = 521
constant hbp:       unsigned(9 downto 0) := "0010010000"; -- horizontal back porch = 128 + 16 = 144 ou 96 + 48
constant hfp:       unsigned(9 downto 0) := "1100010000"; -- horizontal front porch = 128 + 16 + 640 = 784
constant vbp:       unsigned(9 downto 0) := "0000011111"; -- vertical back porch = 2 + 29 = 31
constant vfp:       unsigned(9 downto 0) := "0111111111"; -- vertical front porch = 2 + 29 + 480 = 511

signal hcs, vcs: unsigned(9 downto 0); -- compteurs horizontal / vertical
signal vsenable: std_logic; -- enable pour le compteur vertical

begin
------------------------------------------------------------
-- Compteur pour le signal de synchronisation horizontale
------------------------------------------------------------
process(clk, rst)
begin
    if rising_edge(clk) then
        if rst = '1' then
            hcs <= (others => '0');
        else
            if hcs = hpixels - 1 then
                hcs <= (others => '0');
            else
                hcs <= hcs + 1;
            end if;
        end if;
    end if;
end process;
------------------------------------------------------------
process(hcs)
begin
    if hcs = hpixels - 1 then
        vsenable <= '1';
    else
        vsenable <= '0';
    end if;
end process;

------------------------------------------------------------
-- Compteur pour le signal de synchronisation verticale
------------------------------------------------------------
process(clk, rst)
begin
    if rising_edge(clk) then
        if rst = '1' then
            vcs <= (others => '0');
        
        elsif vsenable = '1' then  
            if vcs = vlines - 1 then
                vcs <= (others => '0');
            else 
                vcs <= vcs + 1;
            end if;
        end if;    
    end if;
end process;

------------------------------------------------------------
-- GENERATION DES SIGNAUX DE SORTIE
------------------------------------------------------------
hsync <= '0' when hcs < 96 else '1';
vsync <= '0' when vcs < 2 else '1';

vidon <= '1' when ( ((hcs < hfp) and (hcs >= hbp)) and ((vcs < vfp) and (vcs >= vbp)) ) else '0';
    
hc <= std_logic_vector(hcs);
vc <= std_logic_vector(vcs);

end Behavioral;
