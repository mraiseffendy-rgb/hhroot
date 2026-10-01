cat << 'EOF' > Bash.sh
#!/data/data/com.termux/files/usr/bin/bash

# =========================================================
# LINUX ROOT ENVIRONMENT FOR TERMUX - CONFIG.SH VERSION
# =========================================================

CONFIG_FILE="$HOME/config.sh"
[ ! -f "$CONFIG_FILE" ] && CONFIG_FILE="./config.sh"

LAST_MD5=""
declare -A USERS_DATA

# Sembunyikan kursor saat animasi
tput civis 2>/dev/null || true

# Fungsi Memuat & Mendeteksi Perubahan File config.sh
load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        if command -v md5sum >/dev/null 2>&1; then
            CURRENT_MD5=$(md5sum "$CONFIG_FILE" | awk '{print $1}')
        else
            CURRENT_MD5=$(cksum "$CONFIG_FILE" | awk '{print $1}')
        fi

        if [ "$CURRENT_MD5" != "$LAST_MD5" ]; then
            USERS_DATA=()
            
            # Muat variabel USER_LIST dari config.sh
            source "$CONFIG_FILE" 2>/dev/null

            for entry in "${USER_LIST[@]}"; do
                if [[ "$entry" == *":"* ]]; then
                    u_name="${entry%%:*}"
                    u_pass="${entry#*:}"
                    USERS_DATA["$u_name"]="$u_pass"
                fi
            done
            LAST_MD5="$CURRENT_MD5"
        fi
    else
        # Default jika config.sh belum dibuat
        USERS_DATA["Ranz"]="123"
    fi

    if [ ${#USERS_DATA[@]} -eq 0 ]; then
        USERS_DATA["Ranz"]="123"
    fi
}

# Memuat konfigurasi saat pertama kali dijalankan
load_config

# Fungsi Logo Linux (Tux ASCII)
show_logo() {
    clear
    local logo=(
        "\033[31m         .---.         \033[0m"
        "\033[31m        /     \        \033[0m"
        "\033[31m       |       |       \033[0m"
        "\033[31m      / \033[30;47m-     -\033[0m\033[31m \      \033[0m"
        "\033[31m     |   \033[33m(o) (o)\033[0m\033[31m |     \033[0m"
        "\033[31m     |  \033[33m  .---.\033[0m \033[31m |     \033[0m"
        "\033[31m     | \033[33m  /     \\\033[0m\033[31m|     \033[0m"
        "\033[31m     | \033[33m  \___/ \033[0m\033[31m|     \033[0m"
    )

    for line in "${logo[@]}"; do
        for (( i=0; i<${#line}; i++ )); do
            echo -ne "${line:$i:1}"
            sleep 0.0015
        done
        echo ""
    done
    echo ""
    echo -e "\033[1;31m╔══════════════════════════════════════════╗\033[0m"
    echo -e "\033[1;31m║          RANZ MODS ROOT SYSTEM           ║\033[0m"
    echo -e "\033[1;31m╚══════════════════════════════════════════╝\033[0m"
    echo ""
}

# Fungsi Kotak Informasi Sistem
show_info_box() {
    local current_time=$(date +"%H:%M:%S WIB - %d/%m/%Y")
    local total_users=${#USERS_DATA[@]}

    echo -e "\033[1;36m╔══════════════════════════════════════════╗\033[0m"
    echo -e "\033[1;36m║\033[0m \033[1;33mSYSTEM INFORMATION STATUS\033[0m                \033[1;36m║\033[0m"
    echo -e "\033[1;36m╠══════════════════════════════════════════╣\033[0m"
    printf "\033[1;36m║\033[0m \033[1;37m%-13s :\033[0m \033[1;32m%-22s\033[0m \033[1;36m║\033[0m\n" "Registered" "$total_users User(s) in Config"
    printf "\033[1;36m║\033[0m \033[1;37m%-13s :\033[0m \033[1;35m%-22s\033[0m \033[1;36m║\033[0m\n" "Time / Date" "$current_time"
    echo -e "\033[1;36m╚══════════════════════════════════════════╝\033[0m"
    echo ""
}

# Fungsi Loading Bar Anti-Spam
show_loading() {
    echo -e "\033[1;30m[!] Butuh waktu 1-3 menit untuk inisialisasi system...\033[0m\n"
    
    local width=26
    for i in $(seq 1 100); do
        local filled=$(( i * width / 100 ))
        local empty=$(( width - filled ))
        
        local bar=""
        for (( f=0; f<filled; f++ )); do bar="${bar}\033[41m \033[0m"; done
        for (( e=0; e<empty; e++ )); do bar="${bar}\033[40;1m \033[0m"; done
        
        echo -ne "\r\033[1;37mLoading: [${bar}\033[1;37m] ${i}% \033[0m"
        sleep 0.025
    done
    echo -e "\n\n\033[1;32m[✓] Inisialisasi Selesai!\033[0m\n"
    sleep 1
}

# Header Utama
show_header() {
    clear
    load_config
    echo -e "\033[1;32m╔══════════════════════════════════════════╗\033[0m"
    echo -e "\033[1;32m║   WELCOME TO LINUX ROOT ENVIRONMENT      ║\033[0m"
    echo -e "\033[1;32m║   STATUS: ONLINE  |  MODE: ROOT ACCESS   ║\033[0m"
    echo -e "\033[1;32m╚══════════════════════════════════════════╝\033[0m"
    show_info_box
}

# Kelola User di config.sh
manage_users() {
    clear
    show_header
    tput cnorm 2>/dev/null || true

    echo -e "\033[1;33m╔══════════════════════════════════════════╗\033[0m"
    echo -e "\033[1;33m║       KONFIGURASI USER (CONFIG.SH)       ║\033[0m"
    echo -e "\033[1;33m╚══════════════════════════════════════════╝\033[0m"
    echo -e "Daftar User Terdaftar:"
    local count=1
    for u in "${!USERS_DATA[@]}"; do
        echo -e "  \033[1;36m$count.\033[0m Username: \033[1;32m$u\033[0m"
        ((count++))
    done
    echo ""
    echo -e "\033[1;37mFormat input: \033[1;33mUsername:Password\033[0m (Contoh: \033[1;32mRanz:112\033[0m)"
    read -p "Masukkan User Baru / Ubah Pass : " input_user_data

    if [[ "$input_user_data" == *":"* ]]; then
        local new_user="${input_user_data%%:*}"
        local new_pass="${input_user_data#*:}"

        if [[ -z "$new_user" || -z "$new_pass" ]]; then
            echo -e "\n\033[1;31m[!] Format salah! Username dan Password tidak boleh kosong.\033[0m"
            sleep 2
            return
        fi

        USERS_DATA["$new_user"]="$new_pass"

        # Simpan ulang data ke config.sh
        cat << EOF > "$CONFIG_FILE"
# =========================================================
# CONFIGURATION FILE FOR BASH.SH (RANZ MODS ROOT)
# =========================================================

USER_LIST=(
EOF
        for u in "${!USERS_DATA[@]}"; do
            echo "    \"${u}:${USERS_DATA[$u]}\"" >> "$CONFIG_FILE"
        done
        echo ")" >> "$CONFIG_FILE"

        echo -e "\n\033[1;32m[✓] Berhasil menyimpan user '$new_user' ke config.sh!\033[0m"
        load_config
        sleep 2
    else
        echo -e "\n\033[1;31m[!] Format salah! Gunakan pemisah tanda titik dua (:)\033[0m"
        sleep 2
    fi
}

# Terminal Login
terminal_login() {
    clear
    show_header
    tput cnorm 2>/dev/null || true
    
    echo -e "\033[1;33m╔══════════════════════════════════════════╗\033[0m"
    echo -e "\033[1;33m║          LOGIN TERMINAL ROOT             ║\033[0m"
    echo -e "\033[1;33m╚══════════════════════════════════════════╝\033[0m"
    read -p " Username : " input_user
    read -s -p " Password : " input_pass
    echo ""

    load_config

    if [[ -n "${USERS_DATA[$input_user]}" && "${USERS_DATA[$input_user]}" == "$input_pass" ]]; then
        echo -e "\n\033[1;32m[✓] Akses Diterima! Selamat datang, ${input_user}!\033[0m"
        sleep 1
        clear
        
        echo -e "\033[1;31m╔══════════════════════════════════════════╗\033[0m"
        echo -e "\033[1;31m║   LINUX ROOT TERMINAL ENVIRONMENT        ║\033[0m"
        printf "\033[1;31m║   Logged in as: root{%-18s} ║\n" "$input_user"
        echo -e "\033[1;31m║   Ketik 'exit' untuk kembali/logout      ║\033[0m"
        echo -e "\033[1;31m╚══════════════════════════════════════════╝\033[0m"
        echo ""
        
        bash --rcfile <(echo "export PS1='root{${input_user}} $ '")
    else
        echo -e "\n\033[1;31m[!] Username atau Password Salah!\033[0m"
        sleep 2
    fi
}

# Hapus file .env lama jika masih ada
[ -f "$HOME/.env" ] && rm -f "$HOME/.env"

# Jalankan Animasi Awal
show_logo
show_info_box
show_loading

# Menu Utama
while true; do
    tput cnorm 2>/dev/null || true
    show_header
    echo -e "\033[1;36m╔══════════════════════════════════════════╗\033[0m"
    echo -e "\033[1;36m║              MENU OPTIONS                ║\033[0m"
    echo -e "\033[1;36m╠══════════════════════════════════════════╣\033[0m"
    echo -e "\033[1;36m║  1. Exit                                 ║\033[0m"
    echo -e "\033[1;36m║  2. Terminal Login                       ║\033[0m"
    echo -e "\033[1;36m║  3. Konfigurasi User (config.sh)         ║\033[0m"
    echo -e "\033[1;36m╚══════════════════════════════════════════╝\033[0m"
    echo ""
    read -p "Pilih menu [1-3]: " choice

    case $choice in
        1)
            echo -e "\033[1;31mKeluar dari sistem...\033[0m"
            tput cnorm 2>/dev/null || true
            exit 0
            ;;
        2)
            terminal_login
            ;;
        3)
            manage_users
            ;;
        *)
            echo -e "\033[1;31mPilihan tidak valid!\033[0m"
            sleep 1
            ;;
    esac
done
EOF
