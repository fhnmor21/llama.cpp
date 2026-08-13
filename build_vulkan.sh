#!/bin/sh
# source ../vulkan/1.4.350.0/setup-env.sh
cmake -B build_vk -DGGML_VULKAN=ON # -DGLSLC_EXECUTABLE=GLSLC_EXECUTABLE-NOTFOUND
cmake --build build_vk --config Release -j $(nproc)
