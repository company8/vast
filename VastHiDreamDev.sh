#!/bin/bash

source /venv/main/bin/activate

APT_INSTALL="apt-get install -y"

COMFYUI_DIR=${WORKSPACE}/ComfyUI

LLM_MODEL_NAME="Llama-3.1-8B-Lexi-Uncensored-V2-Instruct"

# Packages are installed after nodes so we can fix them...

APT_PACKAGES=(
	"aria2"
)

PIP_PACKAGES=(
    #"package-1"
    #"package-2"
)

NODES=(
	"https://github.com/Comfy-Org/ComfyUI-Manager"
    	#"https://github.com/city96/ComfyUI-GGUF"
    	"https://github.com/kijai/ComfyUI-KJNodes"
	"https://github.com/aria1th/ComfyUI-LogicUtils"
	"https://github.com/ClownsharkBatwing/RES4LYF"
	"https://github.com/rgthree/rgthree-comfy"
 	"https://github.com/company8/ComfyUI-Custom-Scripts"
  	"https://github.com/company8/ComfyUI_LLM_Hub"
	# This repo is in maintenance
	"https://github.com/cubiq/ComfyUI_essentials"
)

DEFAULT_WORKFLOWS=(
	"https://raw.githubusercontent.com/company8/vast/refs/heads/main/hidreamtxt2img.json"
	"https://raw.githubusercontent.com/ClownsharkBatwing/RES4LYF/refs/heads/main/example_workflows/hidream%20style%20transfer%20txt2img.json"
)

#DATASET aka the input folder in ComfyUI
DATASET=(
)

DIFFUSION_MODELS=(
	#"https://huggingface.co/Comfy-Org/HiDream-I1_ComfyUI/resolve/main/split_files/diffusion_models/hidream_i1_dev_bf16.safetensors"
)

DIFFUSERS=(
)

LORA_MODELS=(
)

TEXT_ENCODERS=(
 	#"https://huggingface.co/compan/clip-models/resolve/main/hiDR34MZ_dirtyGCLIP_bf16.safetensors" #NSFW HiDR34MZ dirty clip g
     	#"https://huggingface.co/compan/clip-models/resolve/main/simulacrumCLIP-G-BF16.safetensors" #Clip G Simulacrum
	"https://huggingface.co/compan/clip-models/resolve/main/CLIP-ViT-bigG-14-laion2B-39B-b160k-TE-BF16.safetensors" #Clip G LAION
  	#"https://huggingface.co/compan/clip-models/resolve/main/LongCLIP-SAE-ViT-L-14-BF16.safetensors" #LongClip L Zer0Int
   	"https://huggingface.co/compan/clip-models/resolve/main/LongCLIP-GmP-ViT-L-14-TE-BF16.safetensors" #LongClip L Zer0Int 
    	#"https://huggingface.co/compan/clip-models/resolve/main/CLIP-GmP-ViT-L-14-BF16.safetensors" #Clip L Zer0Int
   	#"https://huggingface.co/compan/flan-t5-xxl-te/resolve/main/flan-t5-xxl-TE-BF16.safetensors" #Flan T5 XXL
    	#"https://huggingface.co/Kaoru8/T5XXL-Unchained/resolve/main/t5xxl-unchained-f16.safetensors" #T5 Unchained XXL
	#"https://huggingface.co/compan/clip-models/resolve/main/CLIP-Flan-T5-TE-with-tokenizer-BF16.safetensors" #CLIP Flan T5 XXL TE-only
     	#"https://huggingface.co/compan/llama-3.1-8B-lexi-uncensored-v2-instruct/resolve/main/model.safetensors" #LLama 3.1 Lexi v2 Uncensored
	#"https://huggingface.co/Comfy-Org/HiDream-I1_ComfyUI/resolve/main/split_files/text_encoders/clip_g_hidream.safetensors" #Official clip G
	#"https://huggingface.co/Comfy-Org/HiDream-I1_ComfyUI/resolve/main/split_files/text_encoders/clip_l_hidream.safetensors" #Official clip L
	#"https://huggingface.co/Comfy-Org/HiDream-I1_ComfyUI/resolve/main/split_files/text_encoders/llama_3.1_8b_instruct_fp8_scaled.safetensors" #Official Llama 3.1 8B
	#"https://huggingface.co/Comfy-Org/HiDream-I1_ComfyUI/resolve/main/split_files/text_encoders/t5xxl_fp8_e4m3fn_scaled.safetensors" #Official T5 XXL
)

LLM_MODEL_FILES=(
	"https://huggingface.co/compan/llama-3.1-8B-lexi-uncensored-v2-instruct/resolve/main/config.json"
	"https://huggingface.co/compan/llama-3.1-8B-lexi-uncensored-v2-instruct/resolve/main/generation_config.json"
	"https://huggingface.co/compan/llama-3.1-8B-lexi-uncensored-v2-instruct/resolve/main/model.safetensors" #LLama 3.1 Lexi v2 Uncensored Instruct
	"https://huggingface.co/compan/llama-3.1-8B-lexi-uncensored-v2-instruct/resolve/main/tokenizer.json"
	"https://huggingface.co/compan/llama-3.1-8B-lexi-uncensored-v2-instruct/resolve/main/tokenizer_config.json"
	"https://huggingface.co/compan/llama-3.1-8B-lexi-uncensored-v2-instruct/resolve/main/special_tokens_map.json"
)

CLIP_VISION=(
)

CLIP_GGUF=(
)

VAE_MODELS=(
	"https://huggingface.co/Comfy-Org/HiDream-I1_ComfyUI/resolve/main/split_files/vae/ae.safetensors"
)

UPSCALE_MODELS=(
)

CONTROLNET_MODELS=(
)

UNET_MODELS=(
)

ESRGAN_MODELS=(
)


### DO NOT EDIT BELOW HERE UNLESS YOU KNOW WHAT YOU ARE DOING ###

function provisioning_start() {
    provisioning_get_default_workflows
    provisioning_print_header
    provisioning_get_apt_packages
    provisioning_update_comfyui
    provisioning_get_nodes
    provisioning_get_pip_packages
    LLM_LOCATION="${COMFYUI_DIR}/models/text_encoders/LLMs/${LLM_MODEL_NAME}"
    workflows_dir="${COMFYUI_DIR}/user/default/workflows"
    mkdir -p "${LLM_SAFES_TARGET_DIR}"
    mkdir -p "${workflows_dir}"
    provisioning_get_files \
        "${workflows_dir}" \
        "${DEFAULT_WORKFLOWS[@]}"
    provisioning_get_files \
        "${LLM_LOCATION}" \
        "${LLM_MODEL_FILES[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/input" \
        "${DATASET[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/diffusion_models" \
        "${DIFFUSION_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/diffusers" \
        "${DIFFUSERS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/unet" \
        "${UNET_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/loras" \
        "${LORA_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/controlnet" \
        "${CONTROLNET_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/text_encoders" \
        "${TEXT_ENCODERS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/clip_vision" \
        "${CLIP_VISION[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/clip_gguf" \
        "${CLIP_GGUF[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/vae" \
        "${VAE_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/upscale_models" \
        "${UPSCALE_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/esrgan" \
        "${ESRGAN_MODELS[@]}"
    provisioning_print_end
}

function provisioning_print_header() {
    echo "‎‎ ‎"
    echo "‎‎ ‎"
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║                                                        ║"
    echo "║                     ¯\_( ͡° ͜ʖ ͡°)_/¯                     ║"
    echo "║                                                        ║"
    echo "║            Setting up environment and tools            ║"
    echo "║             This might take a few minutes.             ║"
    echo "║                                                        ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo "‎‎ ‎"
    echo "‎ ‎‎"
}

function provisioning_get_default_workflows() {
    echo "Injecting default workflow into ComfyUI frontend (via ComfyUI-Custom-Scripts)..."
    index=1
    total=${#DEFAULT_WORKFLOWS[@]}
    start_time=$(date +%s)

    for wf in "${DEFAULT_WORKFLOWS[@]}"; do
        now=$(date +%s)
        elapsed=$((now - start_time))
        eta="--:--"
        if (( index > 1 )); then
            avg=$((elapsed / (index - 1)))
            remaining=$((avg * (total - index + 1)))
            eta=$(date -ud "@$remaining" +%M:%S)
        fi

        filename=$(basename "$wf")
        printf "[%2d/%2d | ETA: %s] Fetching: %s\n" "$index" "$total" "$eta" "$filename"

        workflow_json=$(curl -s "$wf")
        if [[ -n $workflow_json ]]; then
            escaped_json=$(echo "$workflow_json" | python3 -c "import sys, json; print(json.dumps(sys.stdin.read()))")
            echo "export const defaultGraph = JSON.parse($escaped_json);" > \
                "/workspace/ComfyUI/custom_nodes/ComfyUI-Custom-Scripts/defaultGraph.js"
            echo "✅ Workflow injected successfully into ComfyUI-Custom-Scripts"
            return 0
        else
            echo "⚠️  Failed to fetch or empty response from: $wf"
        fi

        ((index++))
    done

    echo "❌ No valid workflow JSON found. Skipping injection."
    return 1
}

# Set to "true" for verbose output
DEBUG_MODE=false
APT_LOG="/tmp/apt_logs.log"
MAX_RETRIES=1

function provisioning_get_apt_packages() {
    if [[ ${#APT_PACKAGES[@]} -eq 0 ]]; then
        echo "No APT packages to install." | tee -a "$APT_LOG"
        return 0
    fi

    total=${#APT_PACKAGES[@]}
    echo "Installing $total APT package(s)..." | tee -a "$APT_LOG"

    index=1
    for pkg in "${APT_PACKAGES[@]}"; do
        printf "[%2d/%2d] Installing: %s\n" "$index" "$total" "$pkg" | tee -a "$APT_LOG"

        retries=0
        success=false
        until $success || ((retries >= MAX_RETRIES)); do
            if sudo apt-get install -y "$pkg" >>"$APT_LOG" 2>&1; then
                echo "✅ Success: $pkg"
                success=true
            else
                ((retries++))
                echo "⚠️ Retry $retries/$MAX_RETRIES for: $pkg" | tee -a "$APT_LOG"
                sleep 1
            fi
        done

        if ! $success; then
            echo "❌ Failed to install: $pkg after $MAX_RETRIES attempts" | tee -a "$APT_LOG"
        fi

        ((index++))
    done
}

# Set to "true" for verbose output
DEBUG_MODE=false
DOWNLOAD_LOG="/tmp/pip_packages.log"
MAX_RETRIES=1

function provisioning_get_pip_packages() {
    if [[ -z ${PIP_PACKAGES[*]} ]]; then
        echo "No PIP packages to install." | tee -a "$DOWNLOAD_LOG"
        return 0
    fi

    total=${#PIP_PACKAGES[@]}
    start_time=$(date +%s)
    echo "Installing $total PIP package(s)" | tee -a "$DOWNLOAD_LOG"

    index=1
    for pkg in "${PIP_PACKAGES[@]}"; do
        now=$(date +%s)
        elapsed=$((now - start_time))
        if (( index > 1 )); then
            avg_time=$((elapsed / (index - 1)))
            remaining=$((avg_time * (total - index + 1)))
            eta=$(date -ud "@$remaining" +%M:%S)
        else
            eta="--:--"
        fi

        printf "[%2d/%2d | ETA: %s] Installing: %s\n" "$index" "$total" "$eta" "$pkg" | tee -a "$DOWNLOAD_LOG"

        (
            retries=0
            success=false
            until $success || ((retries >= MAX_RETRIES)); do
                if pip install --no-cache-dir --verbose "$pkg" 2>&1 | tee -a "$DOWNLOAD_LOG"; then
                    echo "✅ Success: $pkg" | tee -a "$DOWNLOAD_LOG"
                    success=true
                else
                    ((retries++))
                    echo "⚠️ Retry $retries/$MAX_RETRIES for: $pkg" | tee -a "$DOWNLOAD_LOG"
                fi
            done

            if ! $success; then
                echo "❌ Failed to install: $pkg after $MAX_RETRIES attempts" | tee -a "$DOWNLOAD_LOG"
            fi
        )
        ((index++))
    done
    echo "✅ All pip packages installed" | tee -a "$DOWNLOAD_LOG"
}

# We must be at release tag v0.3.34 or greater for fp8 support
# Set to "true" for verbose output
DEBUG_MODE=false
DOWNLOAD_LOG="/tmp/comfyui_update.log"
MAX_RETRIES=1

provisioning_update_comfyui() {
    required_tag="v0.3.34"
    cd "$COMFYUI_DIR" || return 1
    git fetch --all --tags >>"$DOWNLOAD_LOG" 2>&1

    current_commit=$(git rev-parse HEAD)
    required_commit=$(git rev-parse "$required_tag")

    if git merge-base --is-ancestor "$current_commit" "$required_commit"; then
        echo "[Updating] Checking out $required_tag..." | tee -a "$DOWNLOAD_LOG"
        if git checkout "$required_tag" >>"$DOWNLOAD_LOG" 2>&1; then
            echo "[Installing] Dependencies..." | tee -a "$DOWNLOAD_LOG"
            if pip install --no-cache-dir -r requirements.txt >>"$DOWNLOAD_LOG" 2>&1; then
                echo "✅ Success: ComfyUI updated to tag $required_tag" | tee -a "$DOWNLOAD_LOG"
            else
                echo "❌ pip install failed for requirements.txt" | tee -a "$DOWNLOAD_LOG"
                return 1
            fi
        else
            echo "❌ git checkout failed for tag $required_tag" | tee -a "$DOWNLOAD_LOG"
            return 1
        fi
    else
        echo "⏩ Skipping update: Already at or beyond $required_tag" | tee -a "$DOWNLOAD_LOG"
    fi
}

# Set to "true" for verbose output
DEBUG_MODE=true
DOWNLOAD_LOG="/tmp/nodes_logs.log"
MAX_RETRIES=1

function provisioning_get_nodes() {
    total=${#NODES[@]}
    index=1

    for repo in "${NODES[@]}"; do
        dir="${repo##*/}"
        path="${COMFYUI_DIR}/custom_nodes/${dir}"
        requirements="${path}/requirements.txt"
        
        printf "[%2d/%2d] " "$index" "$total" | tee -a "$DOWNLOAD_LOG"

        if [[ -d $path ]]; then
            if [[ ${AUTO_UPDATE,,} != "false" ]]; then
                echo "Updating node: $dir" | tee -a "$DOWNLOAD_LOG"
                ( cd "$path" && git pull >>"$DOWNLOAD_LOG" 2>&1 )
                if [[ -e $requirements ]]; then
                   PYTHONUNBUFFERED=1 pip install --no-cache-dir --verbose -r "$requirements" 2>&1 | tee -a "$DOWNLOAD_LOG"
                fi
                echo "✅ Success: $dir" | tee -a "$DOWNLOAD_LOG"
            else
                echo "Skipping update for node: $dir" | tee -a "$DOWNLOAD_LOG"
            fi
        else
            echo "Cloning node: $dir" | tee -a "$DOWNLOAD_LOG"
            retries=0
            success=false
            until $success || ((retries >= MAX_RETRIES)); do
                if git clone "$repo" "$path" --recursive >>"$DOWNLOAD_LOG" 2>&1; then
                    if [[ -e $requirements ]]; then
                       PYTHONUNBUFFERED=1 pip install --no-cache-dir --verbose -r "$requirements" 2>&1 | tee -a "$DOWNLOAD_LOG"
                    fi
                    echo "✅ Success: $dir" | tee -a "$DOWNLOAD_LOG"
                    success=true
                else
                    ((retries++))
                    echo "⚠️ Retry $retries/$MAX_RETRIES for: $dir" | tee -a "$DOWNLOAD_LOG"
                fi
            done

            if ! $success; then
                echo "❌ Failed to clone: $dir after $MAX_RETRIES attempts" | tee -a "$DOWNLOAD_LOG"
            fi
        fi

        ((index++))
    done
}

# Set to "true" for verbose output
DEBUG_MODE=false
DOWNLOAD_LOG="/tmp/models_logs.log"
MAX_RETRIES=1

function provisioning_get_files() {
    if [[ -z $2 ]]; then return 1; fi

    dir="$1"
    mkdir -p "$dir"
    shift
    arr=("$@")
    total=${#arr[@]}
    start_time=$(date +%s)

    echo "Downloading $total file(s) to $dir" | tee -a "$DOWNLOAD_LOG"

    index=1
    for url in "${arr[@]}"; do
        now=$(date +%s)
        elapsed=$((now - start_time))
        if (( index > 1 )); then
            avg_time=$((elapsed / (index - 1)))
            remaining=$((avg_time * (total - index + 1)))
            eta=$(date -ud "@$remaining" +%M:%S)
        else
            eta="--:--"
        fi

        filename=$(basename "$url")
        printf "[%2d/%2d | ETA: %s] Downloading: %s\n" "$index" "$total" "$eta" "$filename" | tee -a "$DOWNLOAD_LOG"

        (
            retries=0
            success=false
            until $success || ((retries >= MAX_RETRIES)); do
                if provisioning_download "$url" "$dir" >>"$DOWNLOAD_LOG" 2>&1; then
                    echo "✅ Success: $filename" | tee -a "$DOWNLOAD_LOG"
                    success=true
                else
                    ((retries++))
                    echo "⚠️ Retry $retries/$MAX_RETRIES for: $filename" | tee -a "$DOWNLOAD_LOG"
                fi
            done

            if ! $success; then
                echo "❌ Failed to download: $filename after $MAX_RETRIES attempts" | tee -a "$DOWNLOAD_LOG"
            fi
        ) &
        ((index++))
    done
}

function provisioning_print_end() {
    printf "\n⚠️ Wait for models to finish downloading. This may take a while. For any errors, read the logs in the /tmp/ folder.\n\n"
}

function provisioning_has_valid_hf_token() {
    [[ -n "$HF_TOKEN" ]] || return 1
    url="https://huggingface.co/api/whoami-v2"

    response=$(curl -o /dev/null -s -w "%{http_code}" -X GET "$url" \
        -H "Authorization: Bearer $HF_TOKEN" \
        -H "Content-Type: application/json")

    # Check if the token is valid
    if [ "$response" -eq 200 ]; then
        return 0
    else
        return 1
    fi
}

function provisioning_has_valid_civitai_token() {
    [[ -n "$CIVITAI_TOKEN" ]] || return 1
    url="https://civitai.com/api/v1/models?hidden=1&limit=1"

    response=$(curl -o /dev/null -s -w "%{http_code}" -X GET "$url" \
        -H "Authorization: Bearer $CIVITAI_TOKEN" \
        -H "Content-Type: application/json")

    # Check if the token is valid
    if [ "$response" -eq 200 ]; then
        return 0
    else
        return 1
    fi
}

# Download from $1 URL to $2 file path
function provisioning_download() {
    if [[ -n $HF_TOKEN && $1 =~ ^https://([a-zA-Z0-9_-]+\.)?huggingface\.co(/|$|\?) ]]; then
        auth_token="$HF_TOKEN"
    elif [[ -n $CIVITAI_TOKEN && $1 =~ ^https://([a-zA-Z0-9_-]+\.)?civitai\.com(/|$|\?) ]]; then
        auth_token="$CIVITAI_TOKEN"
    fi

    if [[ -n $auth_token && $1 =~ ^https://([a-zA-Z0-9_-]+\.)?huggingface\.co(/|$|\?) ]]; then
        final_url=$(curl -H "Authorization: Bearer $auth_token" -s -L -I -w '%{url_effective}' -o /dev/null "$1")
        filename=$(curl -H "Authorization: Bearer $auth_token" -s -L -I "$final_url" \
            | grep -i 'content-disposition' \
            | sed -n 's/.*filename\*=UTF-8''//;s/.*filename="//;s/";//p')

        # Fallback if filename is empty
        [[ -z "$filename" ]] && filename=$(basename "$final_url")

        aria2c -x 16 -j 8 -s 8 -x 8 -k 10M --max-tries=0 -c --file-allocation=falloc \
            --header="Authorization: Bearer $auth_token" \
            --dir="$2" -o "$filename" "$final_url" \
            --optimize-concurrent-downloads=true

    elif [[ -n $auth_token && $1 =~ ^https://([a-zA-Z0-9_-]+\.)?civitai\.com(/|$|\?) ]]; then
        final_url=$(curl -H "Authorization: Bearer $auth_token" -s -L -I -w '%{url_effective}' -o /dev/null "$1")
        filename=$(basename "$final_url")

        aria2c -x 16 -j 8 -s 8 -x 8 -k 10M --max-tries=0 -c --file-allocation=falloc \
            --header="Authorization: Bearer $auth_token" \
            --dir="$2" -o "$filename" "$final_url" \
            --optimize-concurrent-downloads=true

    else
        # Fallback for public URLs
        filename=$(basename "$1")
        aria2c -x 16 -j 8 -s 8 -x 8 -k 10M --max-tries=0 -c --file-allocation=falloc \
            --dir="$2" -o "$filename" "$1" \
            --optimize-concurrent-downloads=true
    fi
}

# Allow user to disable provisioning if they started with a script they didn't want
if [[ ! -f /.noprovisioning ]]; then
    provisioning_start
    echo "✅ Provisioning complete. Removing /.provisioning"
    rm -f /.provisioning
fi
