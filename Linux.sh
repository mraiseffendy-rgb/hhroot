cat << 'EOF' > LINUX.SH
#!/data/data/com.termux/files/usr/bin/bash

# Folder & File .env
ENV_FILE="$HOME/.env"
LAST_MD5=""

# Sembunyikan kursor saat animasi
tput civis 2>/dev/null || true

# Fungsi Memuat & Mendeteksi Perubahan File .env
load_env() {
    if [ -f "$ENV_FILE" ]; then
        # Hitung MD5 Checksum untuk deteksi perubahan
        if command -v md5sum >/dev/null 2>&1; then
            CURRENT_MD5=$(md5sum "$ENV_FILE" | awk '{print $1}')
        else
            CURRENT_MD5=$(cksum "$ENV_FILE" | awk '{print $1}')
        fi

        if [ "$CURRENT_MD5" != "$LAST_MD5" ]; then
            if [ -n "$LAST_MD5" ]; then
                echo -e "\033[1;33m[!] Terdeteksi perubahan pada .env! Memuat ulang kredensial...\033[0m"
                sleep 1
            fi
            export $(grep -v '^#' "$ENV_FILE" | xargs) 2>/dev/null
            LAST_MD5="$CURRENT_MD5"
        fi
    else
        # Default jika .env tidak ada
        USERNAME="Ranz"
        PASSWORD="123"
    fi

    # Fallback jika variabel di .env kosong
    [ -z "$USERNAME" ] && USERNAME="Ranz"
    [ -z "$PASSWORD" ] && PASSWORD="123"
}

# Memuat .env saat pertama kali dijalankan
load_env

# Fungsi Efek Typing Logo Linux (Titik Merah & Gambar Tux)
show_logo() {
    clear
    local logo=(
        "\033[31m       .---.       \033[0m"
        "\033[31m      /     \      \033[0m"
        "\033[31m     \033[37m|       |\033[0m     "
        "\033[31m    / \033[30;47m-     -\033[0m\033[31m \    \033[0m"
        "\033[31m   |   \033[33m(o) (o)\033[0m\033[31m |   \033[0m"
        "\033[31m   |  \033[33m  .---.\033[0m \033[31m |   \033[0m"
        "\033[31m   | \033[33m  /     \\\033[0m\033[31m|   \033[0m"
        "\033[31m   | \033[33m  \___/ \033[0m\033[31m|   \033[0m"
    )

    for line in "${logo[@]}"; do
        for (( i=0; i<${#line}; i++ )); do
            echo -ne "${line:$i:1}"
            sleep 0.002
        done
        echo ""
    done
    echo ""
    echo -e "\033[1;31m========== Ranz mods root ==========\033[0m"
    echo ""
}

# Fungsi Kotak Informasi (User & Jam)
show_info_box() {
    local current_time=$(date +"%H:%M:%S WIB - %d/%m/%Y")
    local total_users=1

    echo -e "\033[1;36m┌──────────────────────────────────────────┐\033[0m"
    echo -e "\033[1;36m│\033[0m \033[1;33mSYSTEM INFO\033[0m                              \033[1;36m│\033[0m"
    printf "\033[1;36m│\033[0m \033[1;37m%-13s :\033[0m \033[1;32m%-22s\033[0m \033[1;36m│\033[0m\n" "Jumlah User" "$total_users Active User(s)"
    printf "\033[1;36m│\033[0m \033[1;37m%-13s :\033[0m \033[1;35m%-22s\033[0m \033[1;36m│\033[0m\n" "Waktu / Jam" "$current_time"
    echo -e "\033[1;36m└──────────────────────────────────────────┘\033[0m"
    echo ""
}

# Fungsi Loading Bar Anti-Spam (Merah, Hitam, Abu-abu)
show_loading() {
    echo -e "\033[1;30m[!] Butuh waktu 1-3 menit untuk inisialisasi system...\033[0m\n"
    
    local width=30
    for i in $(seq 1 100); do
        local filled=$(( i * width / 100 ))
        local empty=$(( width - filled ))
        
        local bar=""
        for (( f=0; f<filled; f++ )); do bar="${bar}\033[41m \033[0m"; done
        for (( e=0; e<empty; e++ )); do bar="${bar}\033[40;1m \033[0m"; done
        
        echo -ne "\r\033[1;37mLoading: [${bar}\033[1;37m] ${i}% \033[0m"
        sleep 0.03
    done
    echo -e "\n\n\033[1;32m[✓] Inisialisasi Selesai!\033[0m\n"
    sleep 1
}

# Header Utama
show_header() {
    clear
    load_env
    echo -e "\033[1;32mWelcome to Linux Environment (Root Shell)\033[0m"
    echo -e "\033[1;30mSystem Status: ONLINE | Mode: Root Access\033[0m"
    echo -e "----------------------------------------------------"
    show_info_box
}

# Terminal Login dengan Kredensial .env
terminal_login() {
    clear
    show_header
    tput cnorm 2>/dev/null || true
    
    echo -e "\033[1;33m=== LOGIN TERMINAL ROOT ===\033[0m"
    read -p "Username: " input_user
    read -s -p "Password: " input_pass
    echo ""

    load_env # Refresh data kredensial terbaru

    if [[ "$input_user" == "$USERNAME" && "$input_pass" == "$PASSWORD" ]]; then
        echo -e "\n\033[1;32mAkses Diterima! Membuka Terminal Root...\033[0m"
        sleep 1
        clear
        
        # Cetak Header Root + Logo Linux Pojok Kanan Atas
        printf "\033[1;31m%-45s \033[37m    .---.\033[0m\n" "Linux Root Terminal Environment"
        printf "\033[1;30m%-45s \033[37m   /     \\\033[0m\n" "Logged in as: root{$USERNAME}"
        printf "\033[1;30m%-45s \033[37m  | () () |\033[0m\n" "Type 'exit' to logout"
        printf "\033[1;30m%-45s \033[37m   \  =  /\033[0m\n" "----------------------------------------"
        echo ""
        
        # Buka bash shell interaktif dengan custom prompt
        bash --rcfile <(echo "export PS1='root{${USERNAME}} $ '")
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
    echo -e "\033[1;36m[ MENU OPTIONS ]\033[0m"
    echo -e "1. Exit"
    echo -e "2. Terminal Login"
    echo -e ""
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
