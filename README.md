# TRAX
Project for Digital Systems Design - Implementing the TRAX Game in Verilog (A complete description of this game can be found at [Wikipedia](https://en.wikipedia.org/wiki/https://en.wikipedia.org/wiki/Trax_(game)).

Here you can find the files related to:
1. UART Protocol (some of the data here is obtained from [Wikipedia](https://en.wikipedia.org/wiki/Universal_asynchronous_receiver-transmitter)): in this protocol there are two wires:
   1. Rx: for receiving the data. At sampling rates which is defined by a frequency in the system, the value of the incoming bit is considered as the received bit.
   1. Tx: Transmission operation is simpler as the timing does not have to be determined from the line state, nor is it bound to any fixed timing intervals. As soon as the sending system deposits a character in the shift register (after completion of the previous character), the UART generates a start bit, shifts the required number of data bits out to the line, generates and sends the parity bit (if used), and sends the stop bits.
1. Tranceiver:
   1. This module is capable of deciding a right move at each step. According to the game table (which holds the current state of the game) this module calculate a possible move and can send it to the server.
1. TRAX Module:
   1. Final implementation of the TRAX module. One can import this module on two different FPGA boards and those boards can play this game with each other.
