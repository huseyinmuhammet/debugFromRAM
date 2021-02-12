----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/29/2021 02:19:30 PM
-- Design Name: 
-- Module Name: FSM_DEBUG - Behavioral
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
use IEEE.STD_LOGIC_ARITH;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity FSM_DEBUG is
  Port (
        add_in : out STD_LOGIC_VECTOR(13 downto 0);
        data_in : in STD_LOGIC_VECTOR(31 downto 0);
        CLK_100MHZ : in STD_LOGIC;
        CLK_50MHZ : in STD_LOGIC;
        tx : out STD_LOGIC;
        reset : in STD_LOGIC;
        busy_debug : out std_logic;
        start_debug : in std_logic
   );
end FSM_DEBUG;

architecture Behavioral of FSM_DEBUG is

component UART_TX_CTRL is
    Port ( SEND : in  STD_LOGIC;
           DATA : in  STD_LOGIC_VECTOR (7 downto 0);
           CLK : in  STD_LOGIC;
           READY : out  STD_LOGIC;
           UART_TX : out  STD_LOGIC
           );
end component;

type STATE_DEBUG is (INITIAL,PREP, FIRST_BYTE, SECOND_BYTE, THIRD_BYTE, FOURTH_BYTE, 
                     LAST,NXT_ADR,WAIT_SEND );
signal number_bytes : natural range 0 to 3 := 0;
signal state : STATE_DEBUG := INITIAL;
signal ready_data_in_t : STD_LOGIC;
signal send : STD_LOGIC:= '0';
signal data_out : STD_LOGIC_VECTOR(7 downto 0);
signal ready_send : STD_LOGIC;
signal address : STD_LOGIC_VECTOR(13 downto 0):= "00000000000000"; 
signal waitCounter : natural range 0 to 3 := 0;
begin
add_in <= address;
ready_data_in_t <= start_debug;
FSM_DATA_DEBUG : process (CLK_50MHZ)
    begin
    if reset = '1' then
        address <= "00000000000000";
        number_bytes <= 0;    
    elsif RISING_EDGE(CLK_50MHZ)then
        case state is 
            WHEN INITIAL =>
                address <= "00000000000000";
                number_bytes <= 0; 
                if start_debug = '1' then
                    state <= PREP;
                end if;
            WHEN PREP =>
                if( ready_send = '1')then
                    data_out <= data_in(number_bytes * 8 + 7 downto number_bytes * 8);
                    number_bytes <= number_bytes + 1;
                    state <= FIRST_BYTE;
                    send <= '1';
                else
                    send <= '0';
                end if;    
            WHEN FIRST_BYTE =>
                if(ready_send = '1')then
                    data_out <= data_in(number_bytes * 8 + 7 downto number_bytes * 8);
                    send <= '1';
                    number_bytes <= number_bytes + 1;
                    state <= SECOND_BYTE;
                else
                    send <= '0';
                end if;     
            WHEN SECOND_BYTE =>
                if(ready_send = '1')then
                    data_out <= data_in(number_bytes * 8 + 7 downto number_bytes * 8);
                    send <= '1';
                    number_bytes <= number_bytes + 1;
                    state <= THIRD_BYTE;
                else
                    send <= '0';
                end if;   
            WHEN THIRD_BYTE =>
                if(ready_send = '1')then
                    data_out <= data_in(number_bytes * 8 + 7 downto number_bytes * 8);
                    send <= '1';
                    number_bytes <= 0;
                    state <= NXT_ADR;
                else
                    send <= '0';
                end if;   
            WHEN NXT_ADR =>
                send <= '0';
                if address = "11111111111111" then
                   state <= INITIAL;
                else 
                   address <= address + 1;
                   state <= PREP;
                end if;                         
            WHEN OTHERS =>
                state <= INITIAL;
            end case;        
    end if;
    end process;

UART_TX_CTRL_0: UART_TX_CTRL
port map(
    SEND => send,
    data => data_out,
    clk => clk_100mhz,
    ready => ready_send,
    UART_TX => tx
);

end Behavioral;