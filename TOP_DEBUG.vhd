----------------------------------------------------------------------------------
-- Company: Non 
-- Engineer: Hüseyin Görgülü
-- 
-- Create Date: 01/29/2021 04:01:45 PM
-- Design Name: Transferring 32 bit data to Matlab with the FT2232HQ USB-UART Bridge on the Basys-3 board
-- Module Name: TOP_DEBUG - Behavioral
-- Project Name: 
-- Target Devices: Digilent Basys-3
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- I transferred data, which was initilized in the coe file of RAM, through FT2232HQ USB-UART Bridge 
-- on the Basys-3 board. To do that I designed FSNM_DEBUG. To transfer 8 bit data I used prepared code but 
-- to arrage 32 bits data. I prepared finite state machine. To test it I wrote testbench. 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TOP_DEBUG is
  Port (
        btn : in std_logic_vector(4 downto 0);--BASYS3'S BUTTONS(0 AND 1)
        CLK_100MHZ : in STD_LOGIC;--100MHZ CLOCK
        tx : out STD_LOGIC;--BITS TRANSFERRED THROGH  
        led_debug_busy : out STD_LOGIC--ON WHEN DATA IS TRANSFERRING
        );
end TOP_DEBUG;

architecture Behavioral of TOP_DEBUG is

-- FINITE STATE MACHINE OF DEBUG
component FSM_DEBUG is
    Port ( 
        add_in : out STD_LOGIC_VECTOR(13 downto 0);--NUMBER OF ADDRESS IN THE RAM
        data_in : in STD_LOGIC_VECTOR(31 downto 0);--32 BýTS DATA IN EACH RAM ADDRESS
        CLK_100MHZ : in STD_LOGIC;--100MHZ CLOCK
        CLK_50MHZ : in STD_LOGIC;--50MHZ CLOCK
        tx : out STD_LOGIC;--BITS TRANSFERRED THROUG THIS LOGIC
        reset : in STD_LOGIC;--RESET BUTTON
        busy_debug : out std_logic;--ON WHEN BUSY
        start_debug : in std_logic--STARTING TRANSFER
        );
end component;

--RAM PORTS
component blk_mem_gen_0 is
  port (  
    dina : in STD_LOGIC_VECTOR (31 downto 0 );
    addra : in STD_LOGIC_VECTOR (13 downto 0 );
    clka : in STD_LOGIC;
    douta : out STD_LOGIC_VECTOR ( 31 downto 0 );
    ena : in STD_LOGIC;
    wea : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
end component;
-- TO DEBOUNCE BUTTONS ý USED PREPARED CODE
component debouncer
		generic (
			DEBNC_CLOCKS : integer;
			PORT_WIDTH : integer);
		port (
			SIGNAL_I : in std_logic_vector(4 downto 0);
			CLK_I : in std_logic;
			SIGNAL_O : out std_logic_vector(4 downto 0)
		);
	end component;
signal address : STD_LOGIC_VECTOR (13 downto 0);
signal data_in : STD_LOGIC_VECTOR (31 downto 0);
signal btnDeBnc : STD_LOGIC_VECTOR ( 4 downto 0 );
signal busy_debug : std_logic;
signal start_debug : std_logic;
signal clk50mhz : std_logic := '0';
signal dina : STD_LOGIC_VECTOR (31 downto 0):= (others =>'0');
signal count : natural range 0 to 1 := 0;

begin
--CLOCK DIVIDER TO MAKE 100MHZ TO 50MHZ
process(CLK_100MHZ)
begin
if (rising_edge(CLK_100MHZ)) then
    if count = 1 then 
        clk50mhz <= not clk50mhz;
        count <= 0;
    else
        count <= count + 1;    
    end if;
end if;
end process;

DEBUG: FSM_DEBUG
    port map(
        add_in => address,
        data_in => data_in,
        clk_100mhz => CLK_100MHZ,
        CLK_50MHZ => clk50mhz,
        tx => tx,
        reset => btnDeBnc(1),
        start_debug => btnDeBnc(0),--Change btnDeBnc as btn for simulation
        busy_debug => led_debug_busy   
);
memory_block_0: blk_mem_gen_0
    port map(
        dina => dina,
        addra => address,
        clka => clk_100mhz,
        douta => data_in,
        ena => '1',
        wea => ( others => '0')
    ); 
Inst_btn_debounce : debouncer
	generic map(
		DEBNC_CLOCKS => (2 ** 16),
		PORT_WIDTH => 5)
	port map(
		SIGNAL_I => btn,
		CLK_I => clk_100mhz,
		SIGNAL_O => btnDeBnc
	);    
end Behavioral;