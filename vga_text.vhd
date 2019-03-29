library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity vga_text is
	generic (
		hvis : integer := 640;
		vvis : integer := 400
	);
	port (
		rstn : in std_logic;
		clk : in std_logic;
		x : in integer range 0 to (hvis - 1);
		y : in integer range 0 to (vvis - 1);
		data : in std_logic_vector(15 downto 0);
		addr : out std_logic_vector(12 downto 0);
		de : in std_logic;
		r : out std_logic;
		g : out std_logic;
		b : out std_logic;
		ri : out std_logic;
		gi : out std_logic;
		bi : out std_logic
	);
end;

architecture arch of vga_text is

begin

end;
