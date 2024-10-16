----------------------------------------------------------------
-- VGA Example
-- Laura Goncalves
-- Update: 21-03-24
----------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library amba3;
use amba3.ahblite.all;

----------------------------------------------------------------
entity ahblite_my_vga is
port (
	HRESETn     : in  std_logic;
	HCLK        : in  std_logic;
	HSEL        : in  std_logic;
	HREADY      : in  std_logic;

-- FOR VGA conector
     Hsync : out  STD_LOGIC;
     Vsync : out  STD_LOGIC;
     vgaRed : out  STD_LOGIC_VECTOR (3 downto 0);
     vgaGreen : out  STD_LOGIC_VECTOR (3 downto 0);
     vgaBlue : out  STD_LOGIC_VECTOR (3 downto 0);
    
	-- AHB-Lite interface
	AHBLITE_IN  : in  AHBLite_master_vector;
	AHBLITE_OUT : out AHBLite_slave_vector);
end;

----------------------------------------------------------------
architecture arch of ahblite_my_vga is


component  VGA_Basic_ROM_Top is
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
end component ;
----------------------------------------------------------------

    	signal RST : std_logic;

	signal transfer : std_logic;
	signal invalid  : std_logic;
	signal SlaveIn  : AHBLite_master;
	signal SlaveOut : AHBLite_slave;

	signal address  : std_logic_vector(9 downto 2);
	signal lastaddr : std_logic_vector(9 downto 2);
	signal lastwr   : std_logic;

	-- Memory organization:
	-- +--------+--------+---------------------------+
	-- | OFFSET | NAME   | DESCRIPTION               |
	-- +--------+--------+---------------------------+
	-- |  x000  | REG1   | Basic R/W Register      	 |
	-- |  x004  | REG2   | Basic R/W Register      	 |
	-- |  x008  | REG3   | Basic R/W Register      	 |
	-- |  x00C  | REG4   | Basic R/W Register      	 |
	-- +--------+--------+---------------------------+

	signal Background    : std_logic_vector(31 downto 0);
	
	signal X1_Position    : std_logic_vector(31 downto 0);
	signal Y1_Position    : std_logic_vector(31 downto 0);
	
	signal X2_Position    : std_logic_vector(31 downto 0);
	signal Y2_Position    : std_logic_vector(31 downto 0);
	
	signal X3_Position    : std_logic_vector(31 downto 0);
	signal Y3_Position    : std_logic_vector(31 downto 0);
	
	signal X4_Position    : std_logic_vector(31 downto 0);
	signal Y4_Position    : std_logic_vector(31 downto 0);
	
	signal X5_Position    : std_logic_vector(31 downto 0);
	signal Y5_Position    : std_logic_vector(31 downto 0);

----------------------------------------------------------------
begin

U_VGA_CTRL : VGA_Basic_ROM_Top
Port map (
       clk=>HCLK,
       btnR =>RST,
       sw  =>Background(11 downto 0),
       Hsync =>Hsync,
       Vsync =>Vsync,
       vgaRed =>vgaRed,
       vgaGreen =>vgaGreen,
       vgaBlue => vgaBlue,
       X1_Position => X1_Position,    
	   Y1_Position => Y1_Position,
	   X2_Position => X2_Position,    
	   Y2_Position => Y2_Position,
	   X3_Position => X3_Position,    
	   Y3_Position => Y3_Position,
	   X4_Position => X4_Position,    
	   Y4_Position => Y4_Position,
	   X5_Position => X5_Position,    
	   Y5_Position => Y5_Position
       );
       
    RST <= not HRESETn;

	AHBLITE_OUT <= to_vector(SlaveOut);
	SlaveIn <= to_record(AHBLITE_IN);

	transfer <= HSEL and SlaveIn.HTRANS(1) and HREADY;
	-- Invalid if not a 32-bit aligned transfer
	invalid  <= transfer and (SlaveIn.HSIZE(2) or (not SlaveIn.HSIZE(1)) or SlaveIn.HSIZE(0) or SlaveIn.HADDR(1) or SlaveIn.HADDR(0));

	address <= SlaveIn.HADDR(address'range);

	----------------------------------------------------------------
	process (HCLK, HRESETn) begin
		if HRESETn = '0' then
			-- Reset
			SlaveOut.HREADYOUT <= '1';
			SlaveOut.HRESP <= '0';
			SlaveOut.HRDATA <= (others => '0');

			lastwr <= '0';
			lastaddr <= (others => '0');

			-- Reset values
			Background <= (others => '0');
			X1_Position <= (others => '0');
			Y1_Position <= (others => '0');
			X2_Position <= (others => '0');
			Y2_Position <= (others => '0');
			X3_Position <= (others => '0');
			Y3_Position <= (others => '0');
			X4_Position <= (others => '0');
			Y4_Position <= (others => '0');
			X5_Position <= (others => '0');
			Y5_Position <= (others => '0');
			--Reg4 <= (others => '0');


		--------------------------------
		elsif rising_edge(HCLK) then
			-- Error management
			SlaveOut.HREADYOUT <= not invalid;
			SlaveOut.HRESP <= invalid or not SlaveOut.HREADYOUT;

			-- Performe write if requested last cycle and no error occured
			if SlaveOut.HRESP = '0' and lastwr = '1' then
				case lastaddr is
					when x"00" => Background    <= SlaveIn.HWDATA;
					when x"01" => X1_Position    <= SlaveIn.HWDATA;
					when x"02" => Y1_Position    <= SlaveIn.HWDATA;
					when x"03" => X2_Position    <= SlaveIn.HWDATA;
					when x"04" => Y2_Position    <= SlaveIn.HWDATA;
					when x"05" => X3_Position    <= SlaveIn.HWDATA;
					when x"06" => Y3_Position    <= SlaveIn.HWDATA;
					when x"07" => X4_Position    <= SlaveIn.HWDATA;
					when x"08" => Y4_Position    <= SlaveIn.HWDATA;
					when x"09" => X5_Position    <= SlaveIn.HWDATA;
					when x"10" => Y5_Position    <= SlaveIn.HWDATA;
					when others =>
				end case;
			end if;

			-- Check for transfer
			if transfer = '1' and invalid = '0' then
				-- Read operation: retrieve data and fill empty spaces with '0'
				if SlaveIn.HWRITE = '0' then
					SlaveOut.HRDATA <= (others => '0');
					case address is
						when x"00" => SlaveOut.HRDATA    <= Background;
						when x"01" => SlaveOut.HRDATA    <= X1_Position;
						when x"02" => SlaveOut.HRDATA    <= Y1_Position;
						when x"03" => SlaveOut.HRDATA    <= X2_Position;
						when x"04" => SlaveOut.HRDATA    <= Y2_Position;
						when x"05" => SlaveOut.HRDATA    <= X3_Position;
						when x"06" => SlaveOut.HRDATA    <= Y3_Position;
						when x"07" => SlaveOut.HRDATA    <= X4_Position;
						when x"08" => SlaveOut.HRDATA    <= Y4_Position;
						when x"09" => SlaveOut.HRDATA    <= X5_Position;
						when x"10" => SlaveOut.HRDATA    <= Y5_Position;
						when others =>
					end case;
				end if;

				-- Keep address and write command for next cycle
				lastaddr <= address;
				lastwr <= SlaveIn.HWRITE;
			else
				lastwr <= '0';
			end if;
		end if;
	end process;

end;