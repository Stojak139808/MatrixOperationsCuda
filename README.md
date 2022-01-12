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

They function mostly on operator overload, so exations can be written for example as:

Matrixgpu A(5,3);
Matrixgpu B(3,7);
Matrixgpu C = A+B * B * 7.5;

On the outside they function almost the same, with the only diefference being that before using GPU values on host, Matrice.get_values() has to be used
