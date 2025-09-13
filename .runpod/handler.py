import os, json
import runpod

# Simple echo + environment report so Hub tests pass.
# Dual-mode: In "pod" we could run a self-test; for Serverless we start the worker.

def versions():
    try:
        import transformers, datasets, accelerate, peft, bitsandbytes, torch, marimo
        return {
            "torch": torch.__version__,
            "transformers": transformers.__version__,
            "datasets": datasets.__version__,
            "accelerate": accelerate.__version__,
            "peft": peft.__version__,
            "bitsandbytes": getattr(bitsandbytes, "__version__", "unknown"),
            "marimo": marimo.__version__,
        }
    except Exception as e:
        return {"error": str(e)}

async def handler(event):
    payload = event.get("input", {})
    return {"echo": payload, "versions": versions()}

mode = os.getenv("MODE_TO_RUN", "pod")
if mode == "serverless":
    runpod.serverless.start({"handler": handler})
else:
    # local/pod smoke test
    import asyncio
    print("Running handler smoke-test in pod mode:")
    print(asyncio.run(handler({"input": {"ping": "hello"}})))
