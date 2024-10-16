library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

package VGA_Generic_Package is
    
    -- Declare functions
    function TotalPixels(width, height : integer) return integer;   --Used to calculate the Total Number of Pixels
    function log2(n : natural) return natural;                      --Used to calculate the size of the std_logic_vectors
    
----     Declare constants

    constant VGA_WIDTH :        integer := 640;
    constant VGA_HEIGHT :       integer := 480;
    
    constant HORIZONTAL_PULSE:  integer := 96;
    constant HORIZONTAL_BP:     integer := 48;
    constant HORIZONTAL_FP:     integer := 16;
    
    --Do the sale with VERTICAL constants, according to the specifications for a 640x480 VGA display
    constant VERTICAL_PULSE:  integer:= 2; 
    constant VERTICAL_BP:     integer:= 33; 
    constant VERTICAL_FP:     integer:= 10; 
    
    constant w: unsigned(9 downto 0)		:= to_unsigned(20, 10);  --fire 
    constant h: unsigned(9 downto 0)		:= to_unsigned(32, 10);
    
    constant w2: unsigned(9 downto 0)		:= to_unsigned(62, 10); --snake
    constant h2: unsigned(9 downto 0)		:= to_unsigned(60, 10);
    
    constant w3: unsigned(9 downto 0)		:= to_unsigned(7, 10); --EGG
    constant h3: unsigned(9 downto 0)		:= to_unsigned(7, 10);
    
    constant w4: unsigned(9 downto 0)		:= to_unsigned(178, 10); --winner
    constant h4: unsigned(9 downto 0)		:= to_unsigned(49, 10);
    
    constant w5: unsigned(9 downto 0)		:= to_unsigned(127, 10); --lose
    constant h5: unsigned(9 downto 0)		:= to_unsigned(90, 10);
    
    --Find the constant value to be calculated depending on the above mentioned constants
    constant N:                 integer := log2(VGA_WIDTH+HORIZONTAL_PULSE+HORIZONTAL_BP+HORIZONTAL_FP);
    
    constant hpixels:   unsigned(N-1 downto 0) := to_unsigned(VGA_WIDTH + HORIZONTAL_PULSE + HORIZONTAL_BP + HORIZONTAL_FP, N);     
    constant hbp:       unsigned(N-1 downto 0) := to_unsigned(HORIZONTAL_PULSE + HORIZONTAL_BP, N);                                 
    constant hfp:       unsigned(N-1 downto 0) := to_unsigned(VGA_WIDTH + HORIZONTAL_PULSE + HORIZONTAL_BP, N);                     
    
    constant vlines:    unsigned(N-1 downto 0) := to_unsigned(VGA_HEIGHT + VERTICAL_PULSE + VERTICAL_BP + VERTICAL_FP, N);
    constant vbp:       unsigned(N-1 downto 0) := to_unsigned(VERTICAL_PULSE + VERTICAL_BP, N); 
    constant vfp:       unsigned(N-1 downto 0) := to_unsigned(VGA_HEIGHT + VERTICAL_PULSE + VERTICAL_BP, N);        
        
        
    

    
    component VGA_Clock_1 
        Port (reset:   in  STD_LOGIC;
           HCLK : in  STD_LOGIC;
           clk25 : out  STD_LOGIC;
           clk100 : out  STD_LOGIC);
    end component;
    
    component prom_sprite_1 IS
          PORT (
            clka : IN STD_LOGIC;
            addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
            douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
          );
    end component;
    
    component sprite_snake IS
          PORT (
            clka : IN STD_LOGIC;
            addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
          );
    end component;
    
    component sprite_egg IS
          PORT (
            clka : IN STD_LOGIC;
            addra : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
            douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
          );
    end component;
    
    component SPRITE_WINNER IS
          PORT (
            clka : IN STD_LOGIC;
            addra : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
            douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
          );
    end component;
    
    component sprite_lose IS
          PORT (
            clka : IN STD_LOGIC;
            addra : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
            douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
          );
    end component;
    
 -- complete with all the components used in your project

component VGA_Basic_ROM
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
end component;

component VGA_640_x_480
   Port ( rst : in  STD_LOGIC;
          clk : in  STD_LOGIC;
          hsync : out  STD_LOGIC;
          vsync : out  STD_LOGIC;
          hc : out  STD_LOGIC_VECTOR (9 downto 0);
          vc : out  STD_LOGIC_VECTOR (9 downto 0);
          vidon : out  STD_LOGIC);
end component;

component Basic_ROM
   Port ( addr : in  STD_LOGIC_VECTOR (4 downto 0);
          M : out  STD_LOGIC_VECTOR (11 downto 0));
end component;

component clk_100Hz is
    Port ( clk, rst :in std_logic;
    clk100Hz: out std_logic);
end component;



end VGA_Generic_Package;

package body VGA_Generic_Package is

    -- Implementation of the TotalPixels function
    function TotalPixels(width, height : integer) return integer is
    begin
        return width * height;
    end TotalPixels;
    
    -- Implementation of the log2 function
    function log2(n : natural) return natural is
    variable count : natural := 0;
    variable value : natural := n;
    begin
        while value >= 1 loop
            value := value / 2;
            count := count + 1;
        end loop;
        return count;
    end log2;


end VGA_Generic_Package;
