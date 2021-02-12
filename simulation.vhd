----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/01/2021 12:51:39 PM
-- Design Name: 
-- Module Name: simulation - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity simulation is
    Port ( a : in STD_LOGIC);
end simulation;

architecture Behavioral of simulation is

component TOP_DEBUG is
  Port (btn : in std_logic_vector(4 downto 0);
        CLK_100MHZ : in STD_LOGIC;
        tx : out STD_LOGIC; 
        led_debug_busy : out STD_LOGIC
        );
end component;
-- architecture declarative part
  signal  clock : std_ulogic := '1';
  signal t_button : std_logic_vector(4 downto 0):=(others => '0');
begin
-- architecture statement part
    clock <= not clock after 5 ns;
    
    tb1 : process
    begin
        wait for 20ns;
        t_button(0) <= '1';
        wait for 100ns;
        t_button(0) <= '0';
        wait for 5ms;
    end process;
DEBU: TOP_DEBUG
    port map(
          CLK_100MHZ => clock,
          btn => t_button
);
end Behavioral;
