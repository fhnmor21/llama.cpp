#!/bin/sh
export HIPCC="/opt/rocm-7.2.4/bin/amdclang"
export HIPCXX="/opt/rocm-7.2.4/bin/amdclang++"
export HIP_PATH="/opt/rocm-7.2.4"
export PATH="/opt/rocm-7.2.4/bin:$PATH"

cmake -B build_hip -DGGML_HIP=ON -DAMDGPU_TARGETS=gfx1102 -DCMAKE_C_COMPILER=/opt/rocm-7.2.4/llvm/bin/clang  -DCMAKE_CXX_COMPILER=/opt/rocm-7.2.4/llvm/bin/clang++ -DCMAKE_HIP_COMPILER=/opt/rocm-7.2.4/bin/amdclang++
cmake --build build_hip --config Release -j $(nproc) --clean-first
