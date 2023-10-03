SRC=src
OBJ=obj

SRCS=$(wildcard $(SRC)/*.asm)
OBJS=$(patsubst $(SRC)/%.asm, $(OBJ)/%.o, $(SRCS))

BINDIR=bin
BINNAME=cat
BIN=$(BINDIR)/$(BINNAME)

OUTPUTDIR=output

default:$(BIN)
	./$(BIN) makefile src/main.asm

$(OUTPUTDIR):
	mkdir -p $@

$(BINDIR):
	mkdir -p $@


$(BIN): $(OBJS) $(BINDIR)
	ld $(OBJS) -o $@


$(OBJ)/%.o: $(SRC)/%.asm
	mkdir -p $(OBJ)
	nasm -f elf64 -o $@ $<

clean:
	$(RM) -r $(BINDIR)/* $(OBJ)/* $(OUTPUTDIR)/*