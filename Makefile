LD = $(CC)
PREFIX ?= /usr/local
DESTDIR ?= $(PREFIX)
CFLAGS += -std=c99
PATH := $(CURDIR)/bin/:$(CURDIR)/sbin/:$(PATH)
BUILD_ENV ?= release

export PATH

all: utils

.PHONY: test bin install

include env/$(BUILD_ENV).makefile

SUB_MAKEFILES != find src -type f -name '*.makefile'
include $(SUB_MAKEFILES)

#debug tests test: CFLAGS += -ggdb -Wall -Werror
#utils benchmarks: CFLAGS += -DNDEBUG -O2
#benchmarks: CFLAGS += -O2

#utils debug: $(UTILS_C) $(UTILS_SH)
#debug: $(TESTS_C) $(TESTS_SH)
#benchmarks: $(BENCHMARKS_C)

#$(UTILS_C) $(TESTS_C): LDLIBS += $(CFLAGS)

$(C_PROGRAMS):
	@mkdir -p $(@D)
	$(LD) -o $@ $^ $> $(LDLIBS)

$(SH_PROGRAMS):
	@mkdir -p $(@D)
	cp $< $@
	chmod +x $@

submodules-init:
	git submodule init

utils:
tests:
run-tests:
	make depend
	make clean
	make BUILD_ENV=debug tests utils
	sh run-tests.sh $(RUN_TESTS)
	make clean

clean-fast:
	rm -rf test bin sbin init `find src -name '*.o'`

clean: clean-fast
	rm -rf external boot

depend: clean
	makedepend -Y `find src -name '*.c*' -or -name '*.h*'`

install:
	cp -v bin/* $(DESTDIR)/bin/
#	printf '%s\n' $(UTILS_C) $(UTILS_SH) | cpio -pudm $(DESTDIR)/

install-user:
	make install DESTDIR=$(HOME)/.local

# DO NOT DELETE

src/range/range_strdup.o: src/range/def.h src/range/string.h
src/range/streq.o: src/range/def.h src/range/string.h
src/range/test/range.test.o: src/range/string.h src/range/def.h
src/range/test/range.test.o: src/range/string.h
src/range/range_strstr_string.o: src/range/string.h src/range/def.h
src/range/path.o: src/range/def.h
src/range/strstr.o: src/range/def.h src/range/string.h
src/range/range_streq_string.o: src/range/string.h src/range/def.h
src/range/range_atozd.o: src/range/def.h src/range/string.h
src/range/path.o: src/range/def.h src/range/path.h
src/range/string.o: src/range/def.h
src/range/strchr.o: src/range/def.h src/range/string.h
src/log/test/log.test.o: src/log/log.h
src/log/log.o: src/log/log.h
