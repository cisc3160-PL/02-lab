TARGET = bin/kuiper

TESTS = $(wildcard examples/*.kupr)

.PHONY: all test clean

all clean:
	$(MAKE) -C src $@

test: all
	$(TARGET) -c $(TESTS)