cat << 'EOF' > Bash.sh
#!/data/data/com.termux/files/usr/bin/bash

# =========================================================
# LINUX ROOT ENVIRONMENT FOR TERMUX - MULTI USER SUPPORT
# =========================================================

ENV_FILE="$HOME/.env"
LAST_MD5=""

# Sembunyikan kursor saat animasi
tput civis 2>/dev/null || true

# Array untuk menyimpan daftar user & password
declare -A USERS_DATA

# Fungsi Memuat & Mendeteksi Perubahan File .env
load_env() {
    if [ -f "$ENV_FILE" ]; then
        if command -v md5sum >/dev/null 2>&1; then
            CURRENT_MD5=$(md5sum "$ENV_FILE" | awk '{print $1}')
        else
            CURRENT_MD5=$(cksum "$ENV_FILE" | awk '{print $1}')
        fi

        # Deteksi jika file .env diperbarui
        if [ "$CURRENT_MD5" != "$LAST_MD5" ]; then
            if [ -n "$LAST_MD5" ]; then
                echo -e "\033[1;33m[!] Terdeteksi perubahan/user baru pada .env! Memuat ulang...\033[0m"
                sleep 1
            fi
            
            # Reset data user
            USERS_DATA=()

            # Baca semua variabel USER_ di .env
            while IFS='=' read -r key value || [ -n "$key" ]; do
                # Abaikan komentar dan baris kosong
                [[ "$key" =~ ^#.* ]] && continue
                [[ -z "$key" ]] && continue
                
                # Hapus tanda kutip dari nilai
                value=$(echo "$value" | tr -d '"' | tr -d "'")
                
                # Ambil format username:password
                if [[ "$value" == *":"* ]]; then
                    u_name="${value%%:*}"
                    u_pass="${value#*:}"
                    USERS_DATA["$u_name"]="$u_pass"
                fi
            done < "$ENV_FILE"

            LAST_MD5="$CURRENT_MD5"
        fi
    else
        # Fallback jika .env belum ada
        USERS_DATA["Ranz"]="123"
    fi

    # Jika .env kosong, beri user bawaan
    if [ ${#USERS_DATA[@]} -eq 0 ]; then
        USERS_DATA["Ranz"]="123"
    fi
}

# Memuat .env saat pertama kali dijalankan
load_env

# Fungsi Logo Linux (Tux ASCII) Kece & Rapih
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
    printf "\033[1;36m║\033[0m \033[1;37m%-13s :\033[0m \033[1;32m%-22s\033[0m \033[1;36m║\033[0m\n" "Registered" "$total_users User(s) in .env"
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
    load_env # Refresh data user terbaru dari .env
    echo -e "\033[1;32m╔══════════════════════════════════════════╗\033[0m"
    echo -e "\033[1;32m║   WELCOME TO LINUX ROOT ENVIRONMENT      ║\033[0m"
    echo -e "\033[1;32m║   STATUS: ONLINE  |  MODE: ROOT ACCESS   ║\033[0m"
    echo -e "\033[1;32m╚══════════════════════════════════════════╝\033[0m"
    show_info_box
}

# Terminal Login dengan Otentikasi Multi-User
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

    load_env # Pastikan .env terbaru dimuat

    # Cek apakah username ada dan password cocok
    if [[ -n "${USERS_DATA[$input_user]}" && "${USERS_DATA[$input_user]}" == "$input_pass" ]]; then
        echo -e "\n\033[1;32m[✓] Akses Diterima! Selamat datang, ${input_user}!\033[0m"
        sleep 1
        clear
        
        # Cetak Banner Root Terminal Sesuai User yang Login
        echo -e "\033[1;31m╔══════════════════════════════════════════╗\033[0m"
        echo -e "\033[1;31m║   LINUX ROOT TERMINAL ENVIRONMENT        ║\033[0m"
        printf "\033[1;31m║   Logged in as: root{%-18s} ║\n" "$input_user"
        echo -e "\033[1;31m║   Ketik 'exit' untuk kembali/logout      ║\033[0m"
        echo -e "\033[1;31m╚══════════════════════════════════════════╝\033[0m"
        echo ""
        
        # Buka bash shell interaktif dengan prompt root{USER_YANG_LOGIN} $
        bash --rcfile <(echo "export PS1='root{${input_user}} $ '")
    else
        echo -e "\n\033[1;31m[!] Username atau Password Salah!\033[0m"
        sleep 2
    fi
}

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
    echo -e "\033[1;36m╚══════════════════════════════════════════╝\033[0m"
    echo ""
    read -p "Pilih menu [1-2]: " choice

    case $choice in
        1)
            echo -e "\033[1;31mKeluar dari sistem...\033[0m"
            tput cnorm 2>/dev/null || true
            exit 0
            ;;
        2)
            terminal_login
            ;;
        *)
            echo -e "\033[1;31mPilihan tidak valid!\033[0m"
            sleep 1
            ;;
    esac
done
EOF
