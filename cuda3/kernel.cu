//Kacper Stojek 179909
#include <stdio.h>
#include <stdlib.h>

#include "Matrixgpu.h"
#include "Matrix.h"

#include <chrono>
#include <fstream>

void pirnt_textfile(Matrixgpu A, string filename) {

    ofstream out(filename, std::ofstream::out);

    for (int i = 0; i < A.number_of_rows(); ++i) {
        for (int j = 0; j < A.number_of_columns(); ++j) {
            out<<to_string(A.matrix[j][i])<<" ";
        }
        out << "\n";
    }
    
}

void pirnt_textfile(Matrix A, string filename) {

    ofstream out(filename, std::ofstream::out);

    for (int i = 0; i < A.number_of_rows(); ++i) {
        for (int j = 0; j < A.number_of_columns(); ++j) {
            out << to_string(A.matrix[j][i]) << " ";
        }
        out << "\n";
    }

}

void single_test() {

    using std::chrono::high_resolution_clock;
    using std::chrono::duration_cast;
    using std::chrono::duration;
    using std::chrono::milliseconds;

    int mat_size;
    printf("Input A and B size: ");
    scanf("%d", &mat_size);

    float omega = 9;
    float mi = 0;

    Matrixgpu Agpu(mat_size, mat_size);
    Agpu.randomize();
    Agpu.get_values();

    Matrixgpu Bgpu(mat_size, mat_size);
    Bgpu.randomize();
    Bgpu.get_values();

    //copying values
    Matrix Acpu(mat_size, mat_size);
    Matrix Bcpu(mat_size, mat_size);

    for (int i = 0; i < mat_size; ++i) {
        for (int j = 0; j < mat_size; ++j) {
            Acpu.matrix[i][j] = Agpu.matrix[i][j];
            Bcpu.matrix[i][j] = Bgpu.matrix[i][j];
        }
    }
    printf("Calculating C = A*B + A^T * mi + A - B * omega\nStarting test.\n");

    auto t1 = high_resolution_clock::now();
    Matrixgpu Cgpu = Agpu * Bgpu + Agpu.transpose() * mi + Agpu - Bgpu * omega;
    auto t2 = high_resolution_clock::now();

    duration<float, std::milli> gpu_time = t2 - t1;
    printf("Gpu time: %f\n", gpu_time.count());

    auto t3 = high_resolution_clock::now();
    Matrix Ccpu = Acpu * Bcpu + Acpu.transpose() * mi + Acpu - Bcpu * omega;
    auto t4 = high_resolution_clock::now();

    duration<float, std::milli> cpu_time = t4 - t3;
    printf("Cpu time: %f\n%f times faster\n", cpu_time.count(), cpu_time.count() / gpu_time.count());

    Cgpu.get_values();

    pirnt_textfile(Agpu, "A.txt");
    pirnt_textfile(Bgpu, "B.txt");
    pirnt_textfile(Cgpu, "Cgpu.txt");
    pirnt_textfile(Cgpu, "Ccpu.txt");

}

void multiplte_tests() {

    using std::chrono::high_resolution_clock;
    using std::chrono::duration_cast;
    using std::chrono::duration;
    using std::chrono::milliseconds;

    int mat_size = 100;
    float omega = 9;
    float mi = 0;

    printf("n, GPU [ms], CPU [ms], CPU/GPU [ms/ms]\n");

    while (mat_size < 5000) {
        printf("%d ", mat_size);
        Matrixgpu Agpu(mat_size, mat_size);
        Agpu.randomize();
        Agpu.get_values();

        Matrixgpu Bgpu(mat_size, mat_size);
        Bgpu.randomize();
        Bgpu.get_values();

        //copying values
        Matrix Acpu(mat_size, mat_size);
        Matrix Bcpu(mat_size, mat_size);

        for (int i = 0; i < mat_size; ++i) {
            for (int j = 0; j < mat_size; ++j) {
                Acpu.matrix[i][j] = Agpu.matrix[i][j];
                Bcpu.matrix[i][j] = Bgpu.matrix[i][j];
            }
        }

        auto t1 = high_resolution_clock::now();
        Matrixgpu Cgpu = Agpu * Bgpu + Agpu.transpose() * mi + Agpu - Bgpu * omega;
        auto t2 = high_resolution_clock::now();

        duration<float, std::milli> gpu_time = t2 - t1;

        auto t3 = high_resolution_clock::now();
        Matrix Ccpu = Acpu * Bcpu + Acpu.transpose() * mi + Acpu - Bcpu * omega;
        auto t4 = high_resolution_clock::now();

        duration<float, std::milli> cpu_time = t4 - t3;
        printf("%f %f %f\n", cpu_time.count(), gpu_time.count(), cpu_time.count() / gpu_time.count());

        mat_size += 100;
    }

}

__global__ void nullKernel() {

}

int main() {

    nullKernel << <1, 1 >> > ();

    //multiplte_tests();
    
    single_test();

}