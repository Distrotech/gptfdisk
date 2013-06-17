CC=gcc
CXX=g++
CFLAGS+=-D_FILE_OFFSET_BITS=64
CXXFLAGS+=-Wall -D_FILE_OFFSET_BITS=64 -D USE_UTF16
#CXXFLAGS+=-Wall -D_FILE_OFFSET_BITS=64
LDFLAGS+=
LIB_NAMES=crc32 support guid gptpart mbrpart basicmbr mbr gpt bsd parttypes attributes diskio diskio-unix
MBR_LIBS=support diskio diskio-unix basicmbr mbrpart
LIB_OBJS=$(LIB_NAMES:=.o)
MBR_LIB_OBJS=$(MBR_LIBS:=.o)
LIB_HEADERS=$(LIB_NAMES:=.h)
DEPEND= makedepend $(CXXFLAGS)


PREFIX=/usr
BINDIR=$(PREFIX)/sbin
MANDIR=$(PREFIX)/share/man/man8
INSTALL=ginstall

install: all
	$(INSTALL) -D gdisk $(DESTDIR)$(BINDIR)/gdisk
	$(INSTALL) -D cgdisk $(DESTDIR)$(BINDIR)/cgdisk
	$(INSTALL) -D sgdisk $(DESTDIR)$(BINDIR)/sgdisk
	$(INSTALL) -D fixparts $(DESTDIR)$(BINDIR)/fixparts
	$(INSTALL) -D gdisk.8 $(DESTDIR)$(MANDIR)/gdisk.8
	$(INSTALL) -D cgdisk.8 $(DESTDIR)$(MANDIR)/cgdisk.8
	$(INSTALL) -D sgdisk.8 $(DESTDIR)$(MANDIR)/sgdisk.8
	$(INSTALL) -D fixparts.8 $(DESTDIR)$(MANDIR)/fixparts.8

all:	cgdisk gdisk sgdisk fixparts

gdisk:	$(LIB_OBJS) gdisk.o gpttext.o
#	$(CXX) $(LIB_OBJS) gdisk.o gpttext.o $(LDFLAGS) -luuid -o gdisk
	$(CXX) $(LIB_OBJS) gdisk.o gpttext.o $(LDFLAGS) -licuio -licuuc -luuid -lpthread -o gdisk

cgdisk: $(LIB_OBJS) cgdisk.o gptcurses.o
#	$(CXX) $(LIB_OBJS) cgdisk.o gptcurses.o $(LDFLAGS) -luuid -lncurses -o cgdisk
	$(CXX) $(LIB_OBJS) cgdisk.o gptcurses.o $(LDFLAGS) -licuio -licuuc -luuid -lncurses -lpthread -o cgdisk

sgdisk: $(LIB_OBJS) sgdisk.o gptcl.o
#	$(CXX) $(LIB_OBJS) sgdisk.o gptcl.o $(LDFLAGS) -luuid -lpopt -o sgdisk
	$(CXX) $(LIB_OBJS) sgdisk.o gptcl.o $(LDFLAGS) -licuio -licuuc -luuid -lpopt -lpthread -o sgdisk

fixparts: $(MBR_LIB_OBJS) fixparts.o
	$(CXX) $(MBR_LIB_OBJS) fixparts.o $(LDFLAGS) -o fixparts

lint:	#no pre-reqs
	lint $(SRCS)

clean:	#no pre-reqs
	rm -f core *.o *~ gdisk sgdisk cgdisk fixparts

# what are the source dependencies
depend: $(SRCS)
	$(DEPEND) $(SRCS)

$(OBJS):
	$(CRITICAL_CXX_FLAGS) 

# DO NOT DELETE
