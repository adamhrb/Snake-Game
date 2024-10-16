
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.VGA_Generic_Package.all;

entity VGA_Basic_ROM_Top is
    Port ( clk : in  STD_LOGIC;
           btnR : in  STD_LOGIC;
           Hsync : out  STD_LOGIC;
           Vsync : out  STD_LOGIC;
           sw: in  STD_LOGIC_VECTOR (11 downto 0);
           vgaRed : out  STD_LOGIC_VECTOR (3 downto 0);
           vgaGreen : out  STD_LOGIC_VECTOR (3 downto 0);
           vgaBlue : out  STD_LOGIC_VECTOR (3 downto 0);
           X1_Position    : in std_logic_vector(31 downto 0);
	       Y1_Position    : in std_logic_vector(31 downto 0);--fire
	       X2_Position    : in std_logic_vector(31 downto 0); --snake
	       Y2_Position    : in std_logic_vector(31 downto 0);
	       X3_Position    : in std_logic_vector(31 downto 0); --EGG
	       Y3_Position    : in std_logic_vector(31 downto 0);
	       X4_Position    : in std_logic_vector(31 downto 0); --winner
	       Y4_Position    : in std_logic_vector(31 downto 0);
	       X5_Position    : in std_logic_vector(31 downto 0); --lose
	       Y5_Position    : in std_logic_vector(31 downto 0)
	       );

end VGA_Basic_ROM_Top;

architecture Behavioral of VGA_Basic_ROM_Top is


signal rst, clk25, clk100, vidon, s_clk100Hz: std_logic;
signal hc, vc, r1, c1,r2, c2,c3,r3,c4,r4,c5,r5: std_logic_vector(9 downto 0);
signal M :  STD_LOGIC_VECTOR (11 downto 0);
signal M2 :  STD_LOGIC_VECTOR (11 downto 0);
signal M3 :  STD_LOGIC_VECTOR (11 downto 0);
signal M4 :  STD_LOGIC_VECTOR (11 downto 0);
signal M5 :  STD_LOGIC_VECTOR (11 downto 0);
signal addr : STD_LOGIC_VECTOR (9 downto 0);
signal addr2 : STD_LOGIC_VECTOR (11 downto 0);
signal addr3 : STD_LOGIC_VECTOR (5 downto 0);
signal addr4 : STD_LOGIC_VECTOR (13 downto 0);
signal addr5 : STD_LOGIC_VECTOR (13 downto 0);

begin

rst <= btnR;
r1 <= Y1_Position(9 downto 0);
c1 <= X1_Position(9 downto 0);

r2 <= Y2_Position(9 downto 0);
c2 <= X2_Position(9 downto 0);

r3 <= Y3_Position(9 downto 0);
c3 <= X3_Position(9 downto 0);

r4 <= Y4_Position(9 downto 0);
c4 <= X4_Position(9 downto 0);

r5 <= Y5_Position(9 downto 0);
c5 <= X5_Position(9 downto 0);


U1: VGA_Clock_1 port map ( HCLK => clk, reset => rst, clk25=> clk25, clk100 => clk100);
U2: VGA_640_x_480 port map ( rst => rst, clk => clk25, hsync => Hsync, vsync => Vsync, hc => hc, vc => vc, vidon => vidon);
U3: VGA_Basic_ROM port map ( vidon => vidon, hc => hc, vc => vc, M => M, M2 => M2,M3 => M3,M4 => M4,M5 => M5,sw => sw, rom_addr4 => addr, rom_addr_snake => addr2,rom_addr_egg => addr3,rom_addr_winner => addr4,rom_addr_lose => addr5, red => vgaRed, green => vgaGreen, blue => vgaBlue, R1 => r1, C1 => c1, R2 => r2, C2 => c2,C3 => c3, R3 => r3,C4 => c4, R4 => r4,C5 => c5, R5 => r5);
U4: prom_sprite_1 Port Map( clka => clk100, addra => addr, douta => M); 
U5: sprite_snake Port Map( clka => clk100, addra => addr2, douta => M2);
U6: sprite_egg Port Map( clka => clk100, addra => addr3, douta => M3);
U7: SPRITE_WINNER Port Map( clka => clk100, addra => addr4, douta => M4);
U8: sprite_lose Port Map( clka => clk100, addra => addr5, douta => M5);
U9: clk_100Hz Port Map( clk=>clk, rst => rst, clk100Hz =>s_clk100Hz);


end Behavioral;


