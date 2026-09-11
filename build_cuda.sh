#!/bin/sh
cmake -B build_nv -DBUILD_SHARED_LIBS=OFF -DGGML_CUDA=ON
cmake --build build_nv --config Release -j $(nproc) --clean-first
