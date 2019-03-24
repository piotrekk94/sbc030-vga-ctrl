library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity vga_ctrl is
	port (
		rstn : in std_logic;
		clk : in std_logic;
		mode : in std_logic_vector(1 downto 0);
		/* video memory */
		vd : in std_logic_vector(31 downto 16);
		va : out std_logic_vector(12 downto 0);
		voe : out std_logic;
		vrw : out std_logic;
		/* video output */
		hsync : out std_logic;
		vsync : out std_logic;
		r : out std_logic;
		g : out std_logic;
		b : out std_logic;
		ri : out std_logic;
		gi : out std_logic;
		bi : out std_logic
	);
end;

architecture arch of vga_ctrl is

begin

vrw <= '1';
voe <= '0';

end; 
