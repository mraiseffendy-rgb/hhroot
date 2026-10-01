cat << 'EOF' > cool_termux.sh
#!/data/data/com.termux/files/usr/bin/bash

ENV_FILE="$HOME/.env"
LAST_MD5=""

# Fungsi Memuat & Mendeteksi Perubahan File .env
load_env() {
    if [ -f "$ENV_FILE" ]; then
        # Hitung checksum MD5 untuk deteksi perubahan file
        CURRENT_MD5=$(md5sum "$ENV_FILE" | awk '{print $1}')
        
        if [ "$CURRENT_MD5" != "$LAST_MD5" ]; then
            if [ -n "$LAST_MD5" ]; then
                echo -e "\033[1;33m[!] Terdeteksi perubahan pada .env! Memuat ulang kredensial...\033[0m"
                sleep 1
            fi
            export $(grep -v '^#' "$ENV_FILE" | xargs)
            LAST_MD5="$CURRENT_MD5"
        fi
    else
        USERNAME="Ranz"
        PASSWORD="123"
    fi
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
            usleep 1200
        done
        echo ""
    done
    echo ""
    echo -e "\033[1;31m========== Ranz mods root ==========\033[0m"
    echo ""
}

# Fungsi Menampilkan Kotak Informasi (Jumlah User & Jam)
show_info_box() {
    local current_time=$(date +"%H:%M:%S WIB - %d/%m/%Y")
    local total_users=$(who | wc -l)
    if [ "$total_users" -eq 0 ]; then
        total_users=1
    fi

    echo -e "\033[1;36m┌──────────────────────────────────────────┐\033[0m"
    echo -e "\033[1;36m│\033[0m \033[1;33mSYSTEM INFO\033[0m                              \033[1;36m│\033[0m"
    printf "\033[1;36m│\033[0m \033[1;37m%-13s :\033[0m \033[1;32m%-22s\033[0m \033[1;36m│\033[0m\n" "Jumlah User" "$total_users Active User(s)"
    printf "\033[1;36m│\033[0m \033[1;37m%-13s :\033[0m \033[1;35m%-22s\033[0m \033[1;36m│\033[0m\n" "Waktu / Jam" "$current_time"
    echo -e "\033[1;36m└──────────────────────────────────────────┘\033[0m"
    echo ""
}

# Fungsi Loading Bar (Merah, Hitam, Abu-abu) Tanpa Spam
show_loading() {
    echo -e "\033[1;30m[!] Butuh waktu 1-3 menit untuk inisialisasi system...\033[0m\n"
    
    tput civis
    local width=30
    for i in $(seq 1 100); do
        local filled=$(( i * width / 100 ))
        local empty=$(( width - filled ))
        
        local bar=""
        for (( f=0; f<filled; f++ )); do bar="${bar}\033[41m \033[0m"; done
        for (( e=0; e<empty; e++ )); do bar="${bar}\033[40;1m \033[0m"; done
        
        echo -ne "\r\033[1;37mLoading: [${bar}\033[1;37m] ${i}% \033[0m"
        usleep 30000
    done
    echo -e "\n\n\033[1;32m[✓] Inisialisasi Selesai!\033[0m\n"
    tput cnorm
    sleep 1
}

# Header Utama
show_header() {
    clear
    load_env # Cek otomatis apakah file .env telah diubah
    
    echo -e "\033[1;32mWelcome to Linux Environment (Root Shell)\033[0m"
    echo -e "\033[1;30mSystem Status: ONLINE | Mode: Root Access\033[0m"
    echo -e "----------------------------------------------------"
    show_info_box
}

# Terminal Login dengan Verifikasi Kredensial .env
terminal_login() {
    clear
    show_header
    echo -e "\033[1;33m=== LOGIN TERMINAL ROOT ===\033[0m"
    
    read -p "Username: " input_user
    read -s -p "Password: " input_pass
    echo ""

    if [[ "$input_user" == "$USERNAME" && "$input_pass" == "$PASSWORD" ]]; then
        echo -e "\n\033[1;32mAkses Diterima! Membuka Terminal Root...\033[0m"
        sleep 1
        
        clear
        printf "\033[1;31m%-50s \033[37m    .---.\033[0m\n" "Linux Root Terminal Environment"
        printf "\033[1;30m%-50s \033[37m   /     \\\033[0m\n" "Logged in as: root{$USERNAME}"
        printf "\033[1;30m%-50s \033[37m  | () () |\033[0m\n" "Type 'exit' to logout"
        printf "\033[1;30m%-50s \033[37m   \  =  /\033[0m\n" "----------------------------------------"
        echo ""
        
        # Membuka bash interaktif dengan prompt custom root{user} $
        /data/data/com.termux/files/usr/bin/bash --rcfile <(echo "PS1='root{${USERNAME}} $ '")
    else
        echo -e "\n\033[1;31m[!] Username atau Password Salah!\033[0m"
        sleep 2
    fi
}

# Eksekusi Animasi Awal
show_logo
show_info_box
show_loading

# Menu Utama
while true; do
    show_header
    echo -e "\033[1;36m[ MENU OPTIONS ]\033[0m"
    echo -e "1. Exit"
    echo -e "2. Terminal Login"
    echo -e ""
    read -p "Pilih menu [1-2]: " choice

    case $choice in
        1)
            echo -e "\033[1;31mKeluar dari sistem...\033[0m"
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
