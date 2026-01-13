#!/bin/bash 
# @file llm-router
# @brief Function to route a determined prompt to a certain llm function
# @description
#   Author: rafmartom (A T) gmail (D O T) com

source "${current_dir}"/../src/google.sh

function show_available_llm() {
cat << 'EOF'
    "google:<model_string>" : "curl -s "https://raw.githubusercontent.com/BerriAI/litellm/main/model_prices_and_context_window.json" | jq 'keys[] | select(contains("gemini"))'"
EOF

}

function llm-router() {
    local prompt="$1"
    local model_string="$2"

    # Everything before the last colon
    local provider="${model_string%:*}"

    # Everything after the first colon
    local model="${model_string#*:}"

    case "${provider}" in
        google)
            google "${prompt}" "${model}"
            ;;
        -*)
            echo "[Error] Unknown provider: $provider" >&2
            show_available_llm
            ;;
    esac
    
}
