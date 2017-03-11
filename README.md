# Simple-CPU

It simulates a 4-instruction CPU introduced in the textbook
Computer Systems Organization and Architecture. 

Is an 8-bit processor with a 64-byte
address space. It interfaces to memory via a 6-bit address
bus and an 8-bit system data bus. The Very Simple CPU
does not use isolated I/O, so only a READ signal is included
in the system's control bus. 

The instruction set architecture of the Very Simple CPU
includes a single register that can be controlled directly by
the programmer. The accumulator, AC, is an 8-bit register. It
receives the result of any arithmetic or logical operation and 
Session T2F
0-7803-7444-4/02/$17.00 © 2002 IEEE November 6-9, 2002, Boston, MA
32nd ASEE/IEEE Frontiers in Education Conference
T2F-12
provides one of the operands for arithmetic and logical
instructions that use two operands. The second operand
comes directly from memory.
There are several other registers in this CPU which are
not a part of the instruction set architecture, but which the
CPU uses to perform the internal operations necessary to
fetch, decode, and execute instructions. These registers are
fairly standard, and are found in many CPUs. The Very
Simple CPU contains the following registers.

- A 6-bit Address Register, AR, which supplies an address to memory via address pins A[5..0]
- A 6-bit Program Counter, PC, which contains the address of the next instruction to be executed
- An 8-bit Data Register, DR, which receives instructions and data from memory via data pins D[7..0]
- A 2-bit Instruction Register, IR, which stores the opcode fetched from memory
