# warn if format string is a literal
warnings := -Wall -Wextra -Wunused -Wformat=2 -Winit-self -Wmissing-include-dirs -Wstrict-overflow=4 -Wfloat-equal -Wreorder -Wsign-promo -Wwrite-strings -Wconversion -Wlogical-op -Wundef -Wunsafe-loop-optimizations -Wtrigraphs -Wunused-parameter -Wunknown-pragmas -Wcast-align -Wswitch-default -Wswitch-enum -Wmissing-noreturn -Wmissing-format-attribute -Wpacked -Wredundant-decls -Wunreachable-code -Winline -Winvalid-pch -Wmissing-declarations -Wdisabled-optimization -Wstack-protector -Woverloaded-virtual -Wsign-promo -Woverloaded-virtual -Wold-style-cast -Wstrict-null-sentinel -Wunused-macros
# -Weffc++
#-Waggregate-return : aggrevating is more the term.
osdevops :=-nostdinc++ -nostdinc -nostartfiles -fno-exceptions -fno-builtin -fno-stack-protector -nostdlib -nodefaultlibs -fno-rtti

experimentalops := -fextended-identifiers

assembly_output :=-masm=intel -save-temps

fthings := -fstrict-aliasing -fno-rtti

# Compiling C++ no matter what the file extensions are when invoking gcc.
cxx_selection := -std=gnu++0x -x c++

includes := -I./src

ignore_define := -U i386

args := ${warnings} ${fthings} ${osdevops} ${experimentalops} \
-Wwrite-strings ${includes} ${cxx_selection} -m32 ${ignore_define} \
-O3

CXX ?= g++
CXX_CHECK_SYNTAX := /usr/x86_64-pc-linux-gnu/i686-pc-linux-gnu/gcc-bin/4.5.0/i686-pc-linux-gnu-gcc

GRUB_STAGE2 := stage2_eltorito


# CXXOPS
# LDFLAGS
# non source files.
AUXFILES := Makefile

PROJDIRS := src
SRCFILES := $(shell find -name "*.cpp")
HDRFILES := $(shell find -name "*.h")

OBJFILES := $(patsubst %.cpp,%.o,$(SRCFILES))
DEPFILES := $(patsubst %.cpp,%.d,$(SRCFILES))

# declare that these rules don't exist elsewhere.
.PHONY: all clean dist test testdrivers todolist

all: O.Os.bin

O.Os.bin: $(OBJFILES)
@nasm -f elf -o loader.o loader.s
${LD} ${LDFLAGS} -melf_i386 -nostdlib -T linker.ld -o O.Os.bin loader.o ${OBJFILES}
@echo "Done! Linked the following into O.Os.bin:" ${OBJFILES}

%.o: %.cpp Makefile
@$(CXX) $(args) -MMD -MP -MT "$*.d $*.o" -c $< -o $@
@echo "Compiled" $<

floppy:
dd if=/dev/zero of=pad bs=1 count=750
cat /boot/grub/stage1 /boot/grub/stage2 pad O.Os.bin > floppy.img

check-syntax:
${CXX_CHECK_SYNTAX} ${args} -o /dev/null -c ${CHK_SOURCES}

clean:
$(RM) $(wildcard $(OBJFILES) $(DEPFILES) $(REGFILES) \
O.Os.bin O.Os.iso)

grub:
@mkdir -p isofiles/boot/grub
@cp ${GRUB_STAGE2} isofiles/boot/grub/
@cp O.Os.bin isofiles/boot

@genisoimage -R -b boot/grub/stage2_eltorito -no-emul-boot -boot-load-size 4 -boot-info-table --input-charset utf-8 -o O.Os.iso isofiles

qemu: grub
qemu -monitor stdio -cdrom O.Os.iso

doxygen: all
@echo No .doxygenrc
#doxygen .doxygenrc

t:
@echo ${CXX}
