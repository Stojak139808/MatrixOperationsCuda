# MatrixOperationsCuda

Matrixgpu object allows to execute matrix operations which are:
  multiplication by matrix,
  multiplication by scalar, 
  addition, 
  substraction, 
  transposition, 
  hadamard product,
  fill,
  randomize
on GPU using CUDA.
Matrix object allows to execute same operations as Matrixgpu, but on CPU

Both objects can do these operations on any arbitrary sized, MxN matrices.

They function mostly on operator overload, so equations can be written for example as:

Matrixgpu A(5,3);
Matrixgpu B(3,7);
Matrixgpu C = A+B * B * 7.5;

On the outside the functions are almost the same, with the only diefference being that before using GPU values on host, Matrix.get_values() has to be used
in order to download data from gpu to host.

Additionaly the program test.cu is used for simple benchmarking of host and device.

When calling single_test(), the program will ask for a matrix size, then it will create two NxN matrices with random values, where N is the given number.
After that it will calculate C = A\*B + A^T \* mi + A - B \* omega, where mi and omega are some scalars and return process time for CPU and GPU.

Alternatively multiple_tests() can be run, to automatically do the same test, for increasing size of matrices.

Note: The program can crash for very big values due to the lack of memory on device, since it's assumed that there is enough memory on GPU.
