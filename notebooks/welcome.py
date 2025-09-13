# marimo
import marimo as mo

# A tiny HF demo cell
import os
HF_TOKEN = os.getenv("HF_TOKEN", None)

with mo.status.spinner("Loading small instruct model..."):
    from transformers import AutoTokenizer, AutoModelForCausalLM, pipeline
    mdl = "Qwen/Qwen2.5-0.5B-Instruct"
    tok = AutoTokenizer.from_pretrained(mdl, token=HF_TOKEN)
    pipe = pipeline("text-generation", model=mdl, tokenizer=tok, device_map="auto")

prompt = mo.ui.text(label="Prompt", value="Explain LoRA in one sentence.")
max_new = mo.ui.slider(16, 256, 64, label="max_new_tokens")
quant = mo.ui.switch(label="Use 8-bit (bitsandbytes)", value=os.getenv("USE_BITSANDBYTES","false")=="true")

@mo.cell
def _():
    return mo.vstack([prompt, max_new, quant])

@mo.cell
def _():
    if prompt.value.strip():
        out = pipe(prompt.value, max_new_tokens=int(max_new.value))[0]["generated_text"]
        return mo.md(f"**Output**:\n\n{out}")
    return mo.md("_Enter a prompt_")
