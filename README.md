# Runpod Marimo LLM Lab (Pod + Serverless)

**One-click Runpod deploy** of a **Marimo** notebook environment (no Jupyter) preloaded with common Hugging Face LLM libraries. The same image also runs as a **Runpod Serverless** worker so it fits the Hub.

[![Run on Runpod Hub](https://img.shields.io/badge/Run%20on-Runpod%20Hub-d326d1)](https://console.runpod.io/hub)

## What you get
- **Marimo** editor (`marimo edit`) or read-only app (`marimo run`) on port `2718`.
- HF stack: `transformers`, `datasets`, `accelerate`, `peft`, `optimum`, `trl`, `safetensors`, `tokenizers`, `sentencepiece`, `evaluate`, optional `bitsandbytes`.
- Dual-mode:
  - **Pod** → Marimo UI
  - **Serverless** → `handler.py` (echo + versions) for Hub validation

## Quick start (Runpod Pod)
1. In Runpod **Pods → New Pod**, use this image (after you push it to a registry or deploy via Hub):

```

<your-registry>/runpod-marimo-lab\:latest

````

2. Set env:
- `MODE_TO_RUN=pod`
- `MARIMO_MODE=edit` (or `run`)
- `MARIMO_PORT=2718`
- Optional: `MARIMO_TOKEN=<password>`, `HF_TOKEN=<hf_xxx>`
3. Expose **port 2718** in the template.
4. Open the Pod; Marimo will be available at the proxied URL.

## Quick start (Serverless / Hub)
- Hub requires a serverless handler and metadata files. This repo includes:
- `.runpod/hub.json` (metadata, presets, CUDA, env form inputs)
- `.runpod/tests.json` (simple echo test)
- `handler.py` (Runpod worker)
- Create a **GitHub Release**, then add the repo in **Runpod → Hub** and publish. (The Hub indexes **releases**, not commits.)  
- You can also deploy from GitHub directly into a Serverless endpoint via the **GitHub integration**.

## Local dev
```bash
docker build -t marimo-lab .
docker run --gpus all -p 2718:2718 -e MODE_TO_RUN=pod -e MARIMO_MODE=edit marimo-lab
# open http://localhost:2718
