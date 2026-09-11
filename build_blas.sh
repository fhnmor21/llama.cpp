#!/bin/sh
cmake -B build_blas -DGGML_BLAS=ON -DGGML_BLAS_VENDOR=OpenBLAS
cmake --build build_blas -j --config Release -j $(nproc)

