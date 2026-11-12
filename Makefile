# Makefile for the project using Verilator in WSL
# Run Testbench: make run TOP=my_tb SRCS="rtl/my_design.sv tb/my_tb.sv"
VERILATOR ?= verilator
TOP ?= chan
SRCS ?= rtl/practice_csp.sv
LIBS ?= lib/systemverilogcsp.sv
VFLAGS ?= -Wno-fatal
JOBS ?= 2
ARGS ?=

BUILD_DIR := obj_dir/$(TOP)
BINARY := $(BUILD_DIR)/V$(TOP)

.DEFAULT_GOAL := build
.PHONY: build run lint clean help

build:
	mkdir -p "$(BUILD_DIR)"
	$(VERILATOR) --binary --timing -j $(JOBS) $(VFLAGS) \
		--top-module $(TOP) --Mdir "$(BUILD_DIR)" $(LIBS) $(SRCS)

run: build
	"./$(BINARY)" $(ARGS)

lint:
	$(VERILATOR) --lint-only --timing $(VFLAGS) \
		--top-module $(TOP) $(LIBS) $(SRCS)

clean:
	rm -rf -- obj_dir

help:
	@echo 'make                 Compile practice_csp (top module: chan)'
	@echo 'make run             Compile and run'
	@echo 'make lint            Check SystemVerilog without building C++'
	@echo 'make clean           Remove generated files in obj_dir'
	@echo 'make run TOP=my_tb SRCS="rtl/my_design.sv tb/my_tb.sv"'
	@echo 'Overrides: LIBS, VFLAGS, JOBS, VERILATOR, ARGS'
