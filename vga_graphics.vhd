library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity vga_graphics is
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
end;

architecture arch of vga_graphics is

signal x_cnt : std_logic_vector(9 downto 0);
signal y_cnt : std_logic_vector(8 downto 0);

signal data_i : std_logic_vector(15 downto 0);

signal de_d, de_dd, de_ddd : std_logic;
signal x_sel_d, x_sel_dd, x_sel_ddd : std_logic_vector(1 downto 0);
signal hsync_d, hsync_dd, hsync_ddd : std_logic;
signal vsync_d, vsync_dd, vsync_ddd : std_logic;

signal rgbi : std_logic_vector(3 downto 0);

signal addr_i : std_logic_vector(12 downto 0);

begin

r <= rgbi(0);
g <= rgbi(1);
b <= rgbi(2);
ri <= rgbi(3);
gi <= rgbi(3);
bi <= rgbi(3);

x_cnt <= std_logic_vector(to_unsigned(x, x_cnt'length));
y_cnt <= std_logic_vector(to_unsigned(y, y_cnt'length));

pipeline : process(rstn, clk)
begin
	if(rstn = '0')then
		de_d <= '0';
		de_dd <= '0';
		de_ddd <= '0';
		
		x_sel_d <= "00";
		x_sel_dd <= "00";
		x_sel_ddd <= "00";
		
		hsync_d <= '0';
		hsync_dd <= '0';
		hsync_ddd <= '0';
		
		vsync_d <= '0';
		vsync_dd <= '0';
		vsync_ddd <= '0';
	elsif(rising_edge(clk))then
		de_d <= de;
		de_dd <= de_d;
		de_ddd <= de_dd;

		x_sel_d <= x_cnt(3 downto 2);
		x_sel_dd <= x_sel_d;
		x_sel_ddd <= x_sel_dd;

		hsync_d <= hsync_i;
		hsync_dd <= hsync_d;
		hsync_ddd <= hsync_dd;

		vsync_d <= vsync_i;
		vsync_dd <= vsync_d;
		vsync_ddd <= vsync_dd;
	end if;
end process;

vsync_o <= vsync_ddd;
hsync_o <= hsync_ddd;

addr_gen : process(rstn, clk)
begin
	if(rstn = '0')then
		addr <= (others => '0');
	elsif(rising_edge(clk))then
		if(de = '1')then
			if(x_cnt(3 downto 0) = "0000")then
				addr <= addr_i;
				addr_i <= std_logic_vector(unsigned(addr_i) + 1);
			elsif(x_cnt(3 downto 0) = "0010")then
				data_i <= data;
			end if;
		else
			if(vsync_i = '1')then
				addr_i <= (others => '0');
				addr <= (others => '0');
			end if;
		end if;
	end if;
end process;

vout_gen : process(rstn, clk)
begin
	if(rstn = '0')then
		rgbi <= (others => '0');
	elsif(rising_edge(clk))then
		if(de_ddd = '1')then
			case x_sel_ddd is
				when "00" =>
					rgbi <= data_i(3 downto 0);
				when "01" =>
					rgbi <= data_i(7 downto 4);
				when "10" =>
					rgbi <= data_i(11 downto 8);
				when "11" =>
					rgbi <= data_i(15 downto 12);
			end case;
		else
			rgbi <= (others => '0');
		end if;
	end if;
end process;

end;
