SOURCES=\
		sarray.c\
		selector.c\
		object_tags.c\
		objc_object.c\
		objc_class.c


OBJECTS=${SOURCES:.c=.o}

CFLAGS   +=-std=c99 -g -Wall -march=native -mtune=native -fPIC -O1
CPPFLAGS +=-DBUILD_TESTS 
LDFLAGS  += -g 

CFLAGS+=${CPPFLAGS}

all: ${OBJECTS}

doc:
	mkdir doc

docs: doc
	cd doc && autogsdoc -MakeFrames YES ../*.h
	
clean:
	@rm -f *.o

objc_class.o: objc_class.c objc_class.h objc_object.h sarray.h selector.h \
  object_tags.h lock.h
objc_object.o: objc_object.c objc_object.h sarray.h selector.h \
  object_tags.h atomic.h
object_tags.o: object_tags.c
sarray.o: sarray.c sarray.h
selector.o: selector.c selector.h sarray.h lock.h
