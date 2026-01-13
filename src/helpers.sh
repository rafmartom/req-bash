#!/bin/bash 
# @file helpers.sh
# @brief Helper functions to be shared across the project.
# @description
#   Author: rafmartom (A T) gmail (D O T) com



## ----------------------------------------------------------------------------
# @section Internal_subroutines
# @description Subroutines that are triggered automatically by other function



# @description Load the .env file
function load_env() {

    ENV_FILE="${current_dir}/../.env"


    if [[ -f "${ENV_FILE}" ]]; then
        source "${ENV_FILE}"
    else
        echo "[Error] Missing .env file" >&2
        echo 'Required:' >&2
        echo 'GEMINI_API_KEY="YOUR_API_KEY"' >&2
        exit 1
    fi

    if [[ -z "${GEMINI_API_KEY}" ]]; then
        echo "[Error] GEMINI_API_KEY is empty" >&2
        exit 1
    fi

}



# @description Building the LLM prompt as a XML envelope, given the script args
function build_prompt() {

    prompt=$(xml_add_entries "prompt" "objective" "${objectives[@]}" )
    prompt=$(xml_add_entries "${prompt}" "prompt" "instruction" "${instructions[@]}" )
    prompt=$(xml_add_entries "${prompt}" "prompt" "context" "${contexts[@]}" )
    prompt=$(xml_add_entries "${prompt}" "prompt" "template" "${templates[@]}" )
    prompt=$(xml_add_entries "${prompt}" "prompt" "question" "${questions[@]}" )
    prompt=$(xml_add_entries "${prompt}" "prompt" "qood_example" "${qood_examples[@]}" )
    prompt=$(xml_add_entries "${prompt}" "prompt" "bad_example" "${bad_examples[@]}" )

    echo "${prompt}"

}



## EOF EOF EOF Internal_subroutines 
## ----------------------------------------------------------------------------




## ----------------------------------------------------------------------------
# @section Cross-Project Utilities


#### @description Add new entries to an xml string given a tag_name and an array
xml_add_entries() {
    local input_xml=""
    local root_name=""
    local tag_name=""

    # 1. Detection and Argument Parsing
    if [[ "$1" =~ ^([[:space:]]*)(\<\?xml|\<) ]]; then
        input_xml=$(echo "$1" | sed 's/<?xml[^>]*?>//g')
        root_name="$2"
        tag_name="$3"
        shift 3
    else
        root_name="$1"
        tag_name="$2"
        shift 2
    fi

    local element_array=("$@")

    # 2. Validation
    if [[ -z "$root_name" || -z "$tag_name" ]]; then
        echo "Error: root_name and tag_name are required" >&2
        return 1
    fi

    # 3. Build the new XML fragment
    local new_entries="<${tag_name}s>"
    local count=1
    for element in "${element_array[@]}"; do
        local escaped_val
        escaped_val=$(xmlstarlet esc "$element")
        new_entries+="<${tag_name}_$count>$escaped_val</${tag_name}_$count>"
        ((count++))
    done
    new_entries+="</${tag_name}s>"

    # 4. Combine and extract
    local raw_combined
    if [[ -n "$input_xml" ]]; then
        # Extract children from ANY existing root-level tag to merge them
        # This XPath finds the first child of our wrapper (the old root) and gets its children
        local existing_content
        existing_content=$(echo "<wrapper>${input_xml}</wrapper>" | \
            xmlstarlet sel -t -c "//wrapper/*/*" 2>/dev/null)

        raw_combined="<${root_name}>${existing_content}${new_entries}</${root_name}>"
    else
        raw_combined="<${root_name}>${new_entries}</${root_name}>"
    fi

    # 5. Final Output
    echo "$raw_combined" | xmlstarlet fo -s 2 2>/dev/null
}


## EOF EOF EOF Cross-Project Utilities
## ----------------------------------------------------------------------------
