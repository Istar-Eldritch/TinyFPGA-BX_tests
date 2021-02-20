
VHDL tests with the tinyfpga bx board.

Requirements:

- YOSYS: https://github.com/YosysHQ/yosys
- Icestorm: https://github.com/YosysHQ/icestorm
- nextpnr: https://github.com/YosysHQ/nextpnr (compile with GUI for inspect functionality)
- GHDL: https://github.com/ghdl/ghdl
- GHDL-YOSYS-PLUGIN: https://github.com/ghdl/ghdl-yosys-plugin
- tinyprog: https://pypi.org/project/tinyprog/

Available demos:
  - blink

Make commands:

```
make install circuit={demo}
make inspect circuit={demo}
make clean
```

Eg.
```
make install circuit=blink
```
