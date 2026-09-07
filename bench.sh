# pre-fill
./build_hip/bin/llama-bench -dev ROCm0 -m /home/bazzite/Work/HF/Qwen3.8-Flash-Next-UD-IQ3_XXS-00001-of-00003.gguf  -t 6  -fa on  -ctk q4_0 -ctv q4_0 -p 64,128,256 -lm mmap -ngl 20 -ncmoe 99  -ub 256,512,1024,2048  -b 2048 -n 0
# generation
