library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.VGA_Generic_Package.all;

entity VGA_Basic_ROM is
    Port ( vidon : in STD_LOGIC;
           hc : in STD_LOGIC_VECTOR (9 downto 0);
           vc : in STD_LOGIC_VECTOR (9 downto 0);
           C1 : in STD_LOGIC_VECTOR (9 downto 0);
           R1 : in STD_LOGIC_VECTOR (9 downto 0);
           C2 : in STD_LOGIC_VECTOR (9 downto 0);
           R2 : in STD_LOGIC_VECTOR (9 downto 0);
           C3 : in STD_LOGIC_VECTOR (9 downto 0);
           R3 : in STD_LOGIC_VECTOR (9 downto 0);
           C4 : in STD_LOGIC_VECTOR (9 downto 0);
           R4 : in STD_LOGIC_VECTOR (9 downto 0);
           C5 : in STD_LOGIC_VECTOR (9 downto 0);
           R5 : in STD_LOGIC_VECTOR (9 downto 0);
           sw : in STD_LOGIC_VECTOR (11 downto 0);
           rom_addr4: out std_logic_vector(9 downto 0);
           rom_addr_snake : out std_logic_vector(11 downto 0);
           rom_addr_egg : out std_logic_vector(5 downto 0);
           rom_addr_winner : out std_logic_vector(13 downto 0);
           rom_addr_lose : out std_logic_vector(13 downto 0);
           M: in std_logic_vector(11 downto 0);
           M2: in std_logic_vector(11 downto 0);
           M3: in std_logic_vector(11 downto 0);
           M4: in std_logic_vector(11 downto 0);
           M5: in std_logic_vector(11 downto 0);
           red : out STD_LOGIC_VECTOR (3 downto 0);
           green : out STD_LOGIC_VECTOR (3 downto 0);
           blue : out STD_LOGIC_VECTOR (3 downto 0)
           );
end VGA_Basic_ROM;

architecture Behavioral of VGA_Basic_ROM is
signal spriteon: STD_LOGIC;
signal spriteon2: STD_LOGIC;
signal spriteon3: STD_LOGIC;
signal spriteon4: STD_LOGIC;
signal spriteon5: STD_LOGIC;
constant hbp: unsigned(9 downto 0)		:= "0010010000"; -- horizontal back porch = 128 + 16 = 144 ou 96 + 48
constant vbp: unsigned(9 downto 0)		:= "0000011111"; -- vertical back porch = 2 + 29 = 31


signal xpix, ypix: unsigned(9 downto 0); --def de R1 et C1
signal xpix2, ypix2: unsigned(9 downto 0); --def de R2 et C2
signal xpix3, ypix3: unsigned(9 downto 0); --def de R3 et C3
signal xpix4, ypix4: unsigned(9 downto 0);
signal xpix5, ypix5: unsigned(9 downto 0);

signal rom_addr_s: std_logic_vector(19 downto 0);
signal rom_addr_s2: std_logic_vector(19 downto 0);
signal rom_addr_s3: std_logic_vector(19 downto 0);
signal rom_addr_s4: std_logic_vector(19 downto 0);
signal rom_addr_s5: std_logic_vector(19 downto 0);

begin



xpix <= unsigned(hc) - (hbp + unsigned(C1));
ypix <= unsigned(vc) - (vbp + unsigned(R1));

rom_addr_s <= std_logic_vector((ypix*w) + xpix);

rom_addr4 <= rom_addr_s(9 downto 0);




spriteon <= '1' when (unsigned(hc) >= unsigned(C1)+hbp and unsigned(hc) < unsigned(C1) + hbp + w and
                      unsigned(vc) >= unsigned(R1)+vbp and unsigned(vc) < unsigned(R1) + vbp + h) 
                     else '0';

process(spriteon,spriteon2,spriteon3,spriteon4,spriteon5,M,M2,M3,M4,M5, vidon)
begin
    red <= (others => '0');
    green <= (others => '0');
    blue <= (others => '0');
  
    if vidon = '1' and spriteon = '1' then
        if M = x"EEE" then
            red <= sw(11 downto 8);
            green <= sw(7 downto 4);
            blue <= sw(3 downto 0);
        else
            red <= M(11 downto 8);
            green <= M(7 downto 4);
            blue <= M(3 downto 0);
        end if;   
    elsif vidon = '1' and spriteon2 = '1'  then
        if M2 = x"EEE" or M2 = x"FFF" then
            red <= sw(11 downto 8);
            green <= sw(7 downto 4);
            blue <= sw(3 downto 0);
        else
            red <= M2(11 downto 8);
            green <= M2(7 downto 4);
            blue <= M2(3 downto 0);
        end if;
    elsif vidon = '1' and spriteon3 = '1' then
        if M3 = x"EEE" or M3 = x"FFF" then
            red <= sw(11 downto 8);
            green <= sw(7 downto 4);
            blue <= sw(3 downto 0);
        else      -- replace sprite background with screen background
            red <= M3(11 downto 8);
            green <= M3(7 downto 4);
            blue <= M3(3 downto 0);
        end if;
    elsif vidon = '1' and spriteon4 = '1' then
        red <= M4(11 downto 8);
        green <= M4(7 downto 4);
        blue <= M4(3 downto 0);
    elsif vidon = '1' and spriteon5 = '1' then
        red <= M5(11 downto 8);
        green <= M5(7 downto 4);
        blue <= M5(3 downto 0);
    elsif vidon ='1' then
        red <= sw(11 downto 8);
        green <= sw(7 downto 4);
        blue <= sw(3 downto 0);
      
    end if;
end process;


xpix2 <= unsigned(hc) - (hbp + unsigned(C2));
ypix2 <= unsigned(vc) - (vbp + unsigned(R2));

rom_addr_s2 <= std_logic_vector((ypix2*w2) + xpix2);
--snake
rom_addr_snake <= rom_addr_s2(11 downto 0);

spriteon2 <= '1' when (unsigned(hc) >= unsigned(C2)+hbp and unsigned(hc) < unsigned(C2) + hbp + w2 and
                      unsigned(vc) >= unsigned(R2)+vbp and unsigned(vc) < unsigned(R2) + vbp + h2) 
                     else '0';




xpix3 <= unsigned(hc) - (hbp + unsigned(C3));
ypix3 <= unsigned(vc) - (vbp + unsigned(R3));

rom_addr_s3 <= std_logic_vector((ypix3*w3) + xpix3);

rom_addr_egg <= rom_addr_s3(5 downto 0);

spriteon3 <= '1' when (unsigned(hc) >= unsigned(C3)+hbp and unsigned(hc) < unsigned(C3) + hbp + w3 and
                      unsigned(vc) >= unsigned(R3)+vbp and unsigned(vc) < unsigned(R3) + vbp + h3) 
                     else '0';
                     
                     
                     
xpix4 <= unsigned(hc) - (hbp + unsigned(C4));
ypix4 <= unsigned(vc) - (vbp + unsigned(R4));

rom_addr_s4 <= std_logic_vector((ypix4*w4) + xpix4);

rom_addr_winner <= rom_addr_s4(13 downto 0);

spriteon4 <= '1' when (unsigned(hc) >= unsigned(C4)+hbp and unsigned(hc) < unsigned(C4) + hbp + w4 and
                      unsigned(vc) >= unsigned(R4)+vbp and unsigned(vc) < unsigned(R4) + vbp + h4) 
                     else '0';
                     
                     
                     
                     
xpix5 <= unsigned(hc) - (hbp + unsigned(C5));
ypix5 <= unsigned(vc) - (vbp + unsigned(R5));

rom_addr_s5 <= std_logic_vector((ypix5*w5) + xpix5);

rom_addr_lose <= rom_addr_s5(13 downto 0);

spriteon5 <= '1' when (unsigned(hc) >= unsigned(C5)+hbp and unsigned(hc) < unsigned(C5) + hbp + w5 and
                      unsigned(vc) >= unsigned(R5)+vbp and unsigned(vc) < unsigned(R5) + vbp + h5) 
                     else '0';

end Behavioral;

