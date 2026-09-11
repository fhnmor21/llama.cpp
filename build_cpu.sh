#!/bin/sh
cmake -B build_cpu -DGGML_AVX512=ON
cmake --build build_cpu -j --config Release -j $(nproc)

