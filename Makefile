.PHONY: DiagROM
VASM=vasmm68k_mot 

all: DiagROM
#compare: DiagROM
#	cmp -l DiagROM.orig DiagROM.new | gawk '{printf "%08X %02X %02X\n", $$1, strtonum(0$$2), strtonum(0$$3)}'	
DiagROM: split date
	$(VASM) -m68882 -no-opt -Fbin $(@).s -o $(@).rom -L $(@).lst
	dd conv=swab if=$(@).rom of=16bit.bin
	./split 16bit.bin 32bit
	cat 32bit.lo 32bit.lo > 32bitLO.bin && rm 32bit.lo
	cat 32bit.hi 32bit.hi > 32bitHI.bin && rm 32bit.hi
split: split.o
	$(CXX) -o split split.o
split.o: split.cpp
date:	
	date +"%d-%b-%y" > BuildDate.txt
mif:
	bin2mif -w 16 DiagROM.rom  > 16bit.mif
clean:
	rm -f DiagROM.new *.lst a.out *~ \#* *.o split
