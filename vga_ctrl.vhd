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

component vga_timing is
	generic (
		hvis : integer := 640;
		hfp : integer := 16;
		hsp : integer := 96;
		hbp : integer := 48;
		vvis : integer := 400;
		vfp : integer := 12;
		vsp : integer := 2;
		vbp : integer := 35
	);
	port (
		rstn : in std_logic;
		clk : in std_logic;
		x : out integer range 0 to (hvis - 1);
		y : out integer range 0 to (vvis - 1);
		de : out std_logic;
		hsync : out std_logic;
		vsync : out std_logic
	);
end component;

component vga_gray is
	generic (
		hvis : integer := 640;
		vvis : integer := 400
	);
	port (
		rstn : in std_logic;
		clk : in std_logic;
		mode : in std_logic;
		x : in integer range 0 to (hvis - 1);
		y : in integer range 0 to (vvis - 1);
		data : in std_logic_vector(15 downto 0);
		addr : out std_logic_vector(12 downto 0);
		de : in std_logic;
		vsync_i : in std_logic;
		hsync_i : in std_logic;
		vsync_o : out std_logic;
		hsync_o : out std_logic;
		r : out std_logic;
		g : out std_logic;
		b : out std_logic;
		ri : out std_logic;
		gi : out std_logic;
		bi : out std_logic
	);
end component;

constant hvis : integer := 640;
constant vvis : integer := 400;

signal x_cnt : integer range 0 to (hvis - 1);
signal y_cnt : integer range 0 to (vvis - 1);
signal vsync_i : std_logic;
signal hsync_i : std_logic;
signal de : std_logic;

signal rstn_d, rstn_dd, rstn_i : std_logic;

begin

rstn_d <= rstn when rising_edge(clk);
rstn_dd <= rstn_d when rising_edge(clk);
rstn_i <= rstn_dd;

vrw <= '1';
voe <= '0';

vtg : vga_timing generic map(
	hvis => hvis,
	vvis => vvis
)port map(
	rstn => rstn_i,
	clk => clk,
	x => x_cnt,
	y => y_cnt,
	de => de,
	hsync => hsync_i,
	vsync => vsync_i
);

vdc : vga_gray generic map(
	hvis => hvis,
	vvis => vvis
)port map(
	rstn => rstn_i,
	clk => clk,
	mode => mode(0),
	x => x_cnt,
	y => y_cnt,
	data => vd,
	addr => va,
	de => de,
	vsync_i => vsync_i,
	hsync_i => hsync_i,
	vsync_o => vsync,
	hsync_o => hsync,
	r => r,
	g => g,
	b => b,
	ri => ri,
	gi => gi,
	bi => bi
);

end; 
