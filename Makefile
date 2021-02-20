
sources := $(wildcard src/*)

default: $(circuit).bin
	

# Load the source files in ghdl, creates the work-obj##.cf file
load: $(sources)
	ghdl -a -fsynopsys $(sources) 

# Uses yosys to to the synthesys for ice40 using the ghdl plugin
%.json: load
	yosys -m /usr/local/share/yosys/plugins/ghdl.so -p 'ghdl -fsynopsys $(circuit); synth_ice40 -json ./build/$@'

# Place and route tool generates the .asc file, this file has blocks of 0 and 1 for the config bits for each tile in the chip.
%.asc: %.json
	nextpnr-ice40 --lp8k --package cm81 --json ./build/$< --pcf pins.pcf --asc ./build/$@

# Converts the .asc file into a native bitstream for the ice40
%.bin: %.asc
	icepack ./build/$< ./build/$@

# Installs the bitstream in the fpga
install: $(circuit).bin
	tinyprog -p ./build/$(circuit).bin

run: load
	ghdl -r $(circuit)

# Runs the place-n-routed viewer
inspect: $(circuit).json
	nextpnr-ice40 --lp8k --package cm81 --json ./build/$(circuit).json --pcf pins.pcf --gui --pcf-allow-unconstrained

clean:
	rm -fr build/*
	rm -f *.cf


