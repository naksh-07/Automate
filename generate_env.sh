set -e

# Define files and their contents
declare -A files_content=(
    ["mac.env"]=""
    ["og.env"]="COMBINED_SERVER_PRIVATE_KEY="
    ["nid.env"]=""
    ["frpc.env"]=""
    ["pop.env"]=$'# RAM allocation (in GB)\nRAM=4\n\n# Maximum disk usage (in GB)\nMAX_DISK=10\n\n# Cache directory path inside Docker\nCACHE_DIR=/data\n\n# Your Solana Public Key (Replace with your actual key)\nSOLANA_PUBKEY=addrs'
    ["node.env"]=""
    ["nmulti.env"]=$'# Bandwidth & Storage\nBANDWIDTH_DOWNLOAD=500\nBANDWIDTH_UPLOAD=250\nSTORAGE=10\n\n# User Credentials (Replace with actual values)\nIDENTIFIER=idfr\nPIN=916524'
)

create_and_secure_files() {
    local file content
    for file in "${!files_content[@]}"; do
        content="${files_content[$file]}"
        printf "%s\n" "$content" > "$file"
        chmod 600 "$file"
    done
}

main() {
    create_and_secure_files
}

main
