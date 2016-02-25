# Makefile to build boxcar diffusion Program 
#
# Andrew J. Pounds, Ph.D.
# Departments of Chemistry and Computer Science
# Mercer University
# Fall 2011 
#

F95 = gfortran   
CC = gcc 

debug ?= n
ifeq ($(debug), y)
    CFLAGS += -g -DDEBUG
else
    CFLAGS += -O3 
endif

ATLASLIBS = -L/usr/lib64/atlas -lblas -llapack -lf77blas -lcblas -latlas

OBJS = array.o zeromat.o walltime.o cputime.o mmm.o  \
       vvm.o 

all: driver atlasdriver 

atlasdriver : atlasdriver.o $(OBJS)    
	$(F95) -o atlasdriver atlasdriver.o $(OBJS) $(ATLASLIBS) 

atlasdriver.o : atlasdriver.f90 array.o   
	$(F95) $(FFLAGS) -c atlasdriver.f90  

driver : driver.o $(OBJS)    
	$(F95) -o driver driver.o $(OBJS)  

driver.o : driver.f90 array.o   
	$(F95) $(FFLAGS) -c driver.f90  

zeromat.o : zeromat.f90    
	$(F95) $(FFLAGS)  -c zeromat.f90  

array.o : array.f90
	$(F95) -c array.f90

mmm.o : mmm.c
	$(CC) $(CFLAGS) $(COPTFLAGS) -c mmm.c

vvm.o : vvm.c
	$(CC) $(CFLAGS) -c vvm.c

# Timing Library targets 

walltime.o : walltime.c
	$(CC)  -c walltime.c

cputime.o : cputime.c
	$(CC)  -c cputime.c

lib: cputime.o walltime.o
	ar -rc liblbstime.a cputime.o walltime.o
	ranlib liblbstime.a

# Default Targets for Cleaning up the Environment
clean :
	rm *.o

pristine :
	rm *.o
	touch *.c *.f90 
	rm *.mod
	rm driver atlasdriver

ctags :
	ctags *.f90

