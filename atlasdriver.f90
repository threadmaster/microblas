program driver 

use array
integer :: DIM

real (kind=8) :: wall_start, wall_end
real (kind=8) :: cpu_start, cpu_end
real (kind=8) :: trace


integer :: startval, stopval, stepval
real (kind=8) :: walltime
real (kind=8) :: cputime 
external walltime, cputime

character (len=8) :: carg1, carg2, carg3

real (kind=8) :: one, zero ! needed for atlas

!modified to use command line arguments

call get_command_argument(1, carg1)
call get_command_argument(2, carg2)
call get_command_argument(3, carg3)

! Use Fortran internal files to convert command line arguments to ints

read (carg1,'(i8)') startval
read (carg2,'(i8)') stopval
read (carg3,'(i8)') stepval
 
do iter = startval, stopval, stepval
  

DIM = iter

allocate ( veca(DIM), stat=ierr)
allocate ( vecb(DIM), stat=ierr)
allocate ( matrixa(DIM,DIM), stat=ierr)
allocate ( matrixb(DIM,DIM), stat=ierr)
allocate ( matrixc(DIM,DIM), stat=ierr)

do i = 1, DIM 
     veca(i) = 1.0
     vecb(i) = 1.0 / sqrt( dble(DIM))
enddo

call zeromat( DIM );

call vvm(DIM, veca, vecb, matrixa);
call vvm(DIM, veca, vecb, matrixb);

wall_start = walltime()
cpu_start = cputime()

one = 1.0D0
zero = 0.0D0

call dgemm('N', 'N', DIM, DIM, DIM, one, matrixa, DIM, &
                                         matrixb, DIM, zero, &
                                         matrixc, DIM )

cpu_end = cputime()
wall_end = walltime()

trace = 0.0;

do i=1, DIM 
     trace = trace + matrixc(i,i)
enddo

!print *,  "The trace is ", trace

mflops  = 2 * dble(DIM)**3/ (cpu_end-cpu_start) / 1.0e6
mflops2 = 2 * dble(DIM)**3/ (wall_end-wall_start)/ 1.0e6
 
print *, DIM, trace, cpu_end-cpu_start, wall_end-wall_start,  mflops, mflops2


!print *, " "
!print *, " Run took ", minutes, " minutes and ", seconds, &
!         " seconds of processor time."
!print *, " "
!print *, " "
!print *, " Run took ", w_minutes, " minutes and ", w_seconds, &
!         " seconds of wall clock time."
!print *, " "

deallocate(matrixa)
deallocate(matrixb)
deallocate(matrixc)
deallocate(veca)
deallocate(vecb)

enddo


end program driver 
 
