library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity vga_timing is
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
end;

architecture arch of vga_timing is

constant x_max : integer := (hvis + hfp + hsp + hbp - 1);
constant y_max : integer := (vvis + vfp + vsp + vbp - 1);

signal x_cnt : integer range 0 to x_max;
signal y_cnt : integer range 0 to y_max;

signal de_x, de_y : std_logic;

signal de_i : std_logic;

begin

de_x <= '1' when x_cnt < hvis else '0';
de_y <= '1' when y_cnt < vvis else '0';

de_i <= de_x and de_y;

de <= de_i;

hsync <= '1' when x_cnt >= hvis + hfp and x_cnt < hvis + hfp + hsp else '0';

vsync <= '1' when y_cnt >= vvis + vfp and y_cnt < vvis + vfp + vsp else '0';

x <= x_cnt when de_i = '1' else 0;
y <= y_cnt when de_i = '1' else 0;

x_inc : process(clk, rstn)
begin
	if(rstn = '0')then
		x_cnt <= 0;
	elsif(rising_edge(clk))then
		if(x_cnt = x_max)then
			x_cnt <= 0;
		else
			x_cnt <= x_cnt + 1;
		end if;
	end if;
end process;

y_inc : process(clk, rstn)
begin
	if(rstn = '0')then
		y_cnt <= 0;
	elsif(rising_edge(clk))then
		if(x_cnt = x_max)then
			if(y_cnt = y_max)then
				y_cnt <= 0;
			else
				y_cnt <= y_cnt + 1;
			end if;
		end if;
	end if;
end process;

end; 
