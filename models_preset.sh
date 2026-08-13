#!/bin/sh
./build_hip/bin/llama-server -dev none --jinja -fa on -t 16 -np 1 -c 64000 -ctk q4_0 -ctv q4_0 -ub 2048 -kvu --reasoning-preserve --repeat-penalty 1.1 -m /home/bazzite/Work/HF/gemma-4-E2B-it-qat-UD-Q4_K_XL.gguf --host 0.0.0.0 --port 8881 &
./build_hip/bin/llama-server -dev none --jinja -fa on -t 16 -np 1 -c 64000 -ctk q4_0 -ctv q4_0 -ub 2048 -kvu --reasoning-preserve --repeat-penalty 1.1 -m /home/bazzite/Work/HF/Qwen3.5-4B-IQ4_NL.gguf --host 0.0.0.0 --port 8882 &
./build_hip/bin/llama-server -dev none --jinja -fa on -t 16 -np 1 -c 64000 -ctk q4_0 -ctv q4_0 -ub 2048 -kvu --reasoning-preserve --repeat-penalty 1.1 -m /home/bazzite/Work/HF/grug-3b-qat-q4-Q4_K_M.gguf --host 0.0.0.0 --port 8883 &
./build_hip/bin/llama-server -dev none --jinja -fa on -t 16 -np 1 -c 64000 -ctk q4_0 -ctv q4_0 -ub 2048 -kvu --reasoning-preserve --repeat-penalty 1.1 -m /home/bazzite/Work/HF/LFM2.5-2.6B-Q4_K_M.gguf --host 0.0.0.0 --port 8884 &
./build_hip/bin/llama-server --models-preset models.ini  --models-max 1 --host 0.0.0.0
