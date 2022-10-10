# vhdl files

FILES = $(wildcard src/*.vhd)

#GHDL CONFIG
GHDL = ghdl
FLAGS  = "--ieee=synopsys"

WORKDIR = "work/"

.PHONY: clean

all: clean make run view

syntax:
	echo $(FILES)
	# @$(GHDL) -s $(FLAGS) $(FILES) --workdir=$(WORKDIR) --work=$(WORKDIR)
	@$(GHDL) -s $(FLAGS) $(FILES) # --workdir=$(WORKDIR) --work=$(WORKDIR)

analysis:
	echo $(FILES)
	@$(GHDL) -a $(FLAGS) $(FILES) --workdir=$(WORKDIR) --work=$(WORKDIR)
	

elaborate:
	@$(GHDL) -a $(FILES) --workdir=$(WORKDIR) 


clean:
	 $(SIMDIR)
	@$(GHDL) --clean --workdir=$(WORKDIR) 
