# -d will generate y.tab.h for lexer to use
# -y will emulate POSIX yacc
YACC = bison -d -y
# Generate lex.yy.c
LEX = flex
CC = gcc
TOP = ..
TARGET = $(TOP)/bin/kuiper

TESTS = $(wildcard $(TOP)/examples/*.kupr)

SRCS = $(filter-out y.tab.c lex.yy.c, $(wildcard *.c))
OBJS := $(SRCS:.c=.o) kuiper.o
DEPS := $(OBJS:.o=.d)

all: $(TARGET)

.PHONY: all

test: all
	$(MAKE) -C $(TOP) $@

%.o: %.c
	$(CC) -MMD -MP -c -o $@ $<

.PHONY: test

y.tab.c y.tab.h: lang.y lex.yy.c
	$(YACC) -o y.tab.c lang.y

lex.yy.c lex.yy.h: lang.l
	$(LEX) --header-file=lex.yy.h -olex.yy.c lang.l

kuiper.o: y.tab.c lex.yy.c
	$(CC) -g -MMD -MP -c y.tab.c -o kuiper.o

$(TARGET): $(OBJS)
	mkdir -p "$$(dirname $(TARGET))"
	$(CC) $(OBJS) -o $(TARGET)

clean:
	rm -f kuiper lex.yy.* y.tab.* *.d *.o $(TARGET)

.PHONY: clean

-include $(DEPS)