#!/bin/bash

source /venv/main/bin/activate

APT_INSTALL="apt-get install -y"

COMFYUI_DIR=${WORKSPACE}/ComfyUI

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
    	"https://github.com/city96/ComfyUI-GGUF"
    	"https://github.com/kijai/ComfyUI-KJNodes"
    	"https://github.com/kijai/ComfyUI-WanVideoWrapper"
	"https://github.com/aria1th/ComfyUI-LogicUtils"
	"https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite"
	"https://github.com/ClownsharkBatwing/RES4LYF"
	"https://github.com/rgthree/rgthree-comfy"
	# This repo is in maintenance
	"https://github.com/cubiq/ComfyUI_essentials"
)

DEFAULT_WORKFLOWS=(
	"https://raw.githubusercontent.com/ClownsharkBatwing/RES4LYF/refs/heads/main/example_workflows/hidream%20txt2img.json"
	"https://raw.githubusercontent.com/ClownsharkBatwing/RES4LYF/refs/heads/main/example_workflows/hidream%20style%20transfer%20txt2img.json"
)

INPUT=(
	"https://comfyanonymous.github.io/ComfyUI_examples/hidream/hidream_dev_example.png"
)

DIFFUSION_MODELS=(
	"https://huggingface.co/Comfy-Org/HiDream-I1_ComfyUI/resolve/main/split_files/diffusion_models/hidream_i1_dev_bf16.safetensors"
)

TEXT_ENCODERS=(
	"https://huggingface.co/Comfy-Org/HiDream-I1_ComfyUI/resolve/main/split_files/text_encoders/clip_g_hidream.safetensors"
	"https://huggingface.co/Comfy-Org/HiDream-I1_ComfyUI/resolve/main/split_files/text_encoders/clip_l_hidream.safetensors"
	"https://huggingface.co/Comfy-Org/HiDream-I1_ComfyUI/resolve/main/split_files/text_encoders/llama_3.1_8b_instruct_fp8_scaled.safetensors"
	"https://huggingface.co/Comfy-Org/HiDream-I1_ComfyUI/resolve/main/split_files/text_encoders/t5xxl_fp8_e4m3fn_scaled.safetensors"
)

UNET_MODELS=(
)

LORA_MODELS=(
)

VAE_MODELS=(
	"https://huggingface.co/Comfy-Org/HiDream-I1_ComfyUI/resolve/main/split_files/vae/ae.safetensors"
)

ESRGAN_MODELS=(
)

CONTROLNET_MODELS=(
)

### DO NOT EDIT BELOW HERE UNLESS YOU KNOW WHAT YOU ARE DOING ###

function provisioning_start() {
    provisioning_get_default_workflows
    provisioning_print_header
    provisioning_get_apt_packages
    provisioning_update_comfyui
    provisioning_get_nodes
    provisioning_get_pip_packages
    workflows_dir="${COMFYUI_DIR}/user/default/workflows"
    mkdir -p "${workflows_dir}"
    provisioning_get_files \
        "${workflows_dir}" \
        "${DEFAULT_WORKFLOWS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/input" \
        "${INPUT[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/diffusion_models" \
        "${DIFFUSION_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/unet" \
        "${UNET_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/lora" \
        "${LORA_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/controlnet" \
        "${CONTROLNET_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/text_encoders" \
        "${TEXT_ENCODERS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/vae" \
        "${VAE_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/esrgan" \
        "${ESRGAN_MODELS[@]}"
    provisioning_print_end
}

function provisioning_get_default_workflows() {
    for wf in "${DEFAULT_WORKFLOWS[@]}"; do
        workflow_json=$(curl -s "$wf")
        if [[ -n $workflow_json ]]; then
            echo "export const defaultGraph = $workflow_json;" > /opt/ComfyUI/web/scripts/defaultGraph.js
            break
        fi
    done
}

function provisioning_get_apt_packages() {
    if [[ -n $APT_PACKAGES ]]; then
            sudo $APT_INSTALL ${APT_PACKAGES[@]}
    fi
}

function provisioning_get_pip_packages() {
    if [[ -n $PIP_PACKAGES ]]; then
            pip install --no-cache-dir ${PIP_PACKAGES[@]}
    fi
}

# We must be at release tag v0.3.34 or greater for fp8 support

provisioning_update_comfyui() {
    required_tag="v0.3.34"
    cd ${COMFYUI_DIR}
    git fetch --all --tags
    current_commit=$(git rev-parse HEAD)
    required_commit=$(git rev-parse "$required_tag")
    if git merge-base --is-ancestor "$current_commit" "$required_commit"; then
        git checkout "$required_tag"
        pip install --no-cache-dir -r requirements.txt
    fi
}

function provisioning_get_nodes() {
    total=${#NODES[@]}
    start_time=$(date +%s)

    for i in "${!NODES[@]}"; do
        repo="${NODES[$i]}"
        index=$((i + 1))
        dir="${repo##*/}"
        path="${COMFYUI_DIR}/custom_nodes/${dir}"
        requirements="${path}/requirements.txt"

        # Color setup
        RED='\033[0;31m'
        GREEN='\033[0;32m'
        YELLOW='\033[0;33m'
        BLUE='\033[0;34m'
        NC='\033[0m' # No Color

        # Estimate ETA
        now=$(date +%s)
        elapsed=$((now - start_time))
        if (( index > 1 )); then
            avg_time=$((elapsed / (index - 1)))
            remaining=$((avg_time * (total - index + 1)))
            eta=$(date -ud "@$remaining" +%M:%S)
        else
            eta="--:--"
        fi

        printf "[ ${RED}%2d${NC}/${GREEN}%2d${NC} | ${YELLOW}ETA: %s${NC} ] Cloning node: ${BLUE}%s${NC}\n" "$index" "$total" "$eta" "$dir"

        if [[ -d $path ]]; then
            if [[ ${AUTO_UPDATE,,} != "false" ]]; then
                ( cd "$path" && git pull )
                [[ -e $requirements ]] && pip install --no-cache-dir -r "$requirements"
            fi
        else
            git clone "$repo" "$path" --recursive
            [[ -e $requirements ]] && pip install --no-cache-dir -r "$requirements"
        fi
    done
}

function provisioning_get_files() {
    if [[ -z $2 ]]; then return 1; fi
    
    dir="$1"
    mkdir -p "$dir"
    shift
    arr=("$@")
    printf "Downloading %s model(s) to %s...\n" "${#arr[@]}" "$dir"
    for url in "${arr[@]}"; do
        printf "Downloading: %s\n" "${url}"
        provisioning_download "${url}" "${dir}" &
    done
}

function provisioning_print_header() {
    printf "\n##############################################\n#                                            #\n#          Provisioning container            #\n#                                            #\n#         This will take some time           #\n#                                            #\n# Your container will be ready on completion #\n#                                            #\n##############################################\n\n"
}

function provisioning_print_end() {
    printf "\nProvisioning complete:  Application will start now\n\n"
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

        aria2c -x 16 -j 4 -k 10M --max-tries=0 -c --file-allocation=falloc \
            --header="Authorization: Bearer $auth_token" \
            --dir="$2" -o "$filename" "$final_url" \
            --optimize-concurrent-downloads=true

    elif [[ -n $auth_token && $1 =~ ^https://([a-zA-Z0-9_-]+\.)?civitai\.com(/|$|\?) ]]; then
        final_url=$(curl -H "Authorization: Bearer $auth_token" -s -L -I -w '%{url_effective}' -o /dev/null "$1")
        filename=$(basename "$final_url")

        aria2c -x 16 -j 8 -k 10M --max-tries=0 -c --file-allocation=falloc \
            --header="Authorization: Bearer $auth_token" \
            --dir="$2" -o "$filename" "$final_url" \
            --optimize-concurrent-downloads=true

    else
        # Fallback for public URLs
        filename=$(basename "$1")
        aria2c -x 16 -j 8 -k 10M --max-tries=0 -c --file-allocation=falloc \
            --dir="$2" -o "$filename" "$1" \
            --optimize-concurrent-downloads=true
    fi
}

# Allow user to disable provisioning if they started with a script they didn't want
if [[ ! -f /.noprovisioning ]]; then
    provisioning_start
fi
