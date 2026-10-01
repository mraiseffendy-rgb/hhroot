cat << 'EOF' > Bash.sh
#!/data/data/com.termux/files/usr/bin/bash

# =========================================================
# LINUX ROOT ENVIRONMENT FOR TERMUX - SINGLE FILE VERSION
# =========================================================

# --- DATABASE USER (DISIMPAN DALAM BASH.SH) ---
USER_LIST=(
    "Ranz:123"
    "Raizdev:112"
)
# --- DATABASE USER (DISIMPAN DALAM BASH.SH) ---
USER_LIST=(
    "Nano:root"
    "Nano:112"
)
# ---------------------------------------------

declare -A USERS_DATA

# Sembunyikan kursor saat animasi
tput civis 2>/dev/null || true

# Fungsi Memuat Data User dari Array Internal
load_users() {
    USERS_DATA=()
    for entry in "${USER_LIST[@]}"; do
        if [[ "$entry" == *":"* ]]; then
            u_name="${entry%%:*}"
            u_pass="${entry#*:}"
            USERS_DATA["$u_name"]="$u_pass"
        fi
    done

    # Fallback jika list kosong
    if [ ${#USERS_DATA[@]} -eq 0 ]; then
        USERS_DATA["Ranz"]="123"
    fi
}

# Memuat user saat script pertama kali dijalankan
load_users

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
    printf "\033[1;36m║\033[0m \033[1;37m%-13s :\033[0m \033[1;32m%-22s\033[0m \033[1;36m║\033[0m\n" "Registered" "$total_users User(s) Internal"
    printf "\033[1;36m║\033[0m \033[1;37m%-13s :\033[0m \033[1;35m%-22s\033[0m \033[1;36m║\033[0m\n" "Time / Date" "$current_time"
    echo -e "\033[1;36m╚══════════════════════════════════════════╝\033[0m"
    echo ""
}

# Fungsi Loading Bar
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
    load_users
    echo -e "\033[1;32m╔══════════════════════════════════════════╗\033[0m"
    echo -e "\033[1;32m║   WELCOME TO LINUX ROOT ENVIRONMENT      ║\033[0m"
    echo -e "\033[1;32m║   STATUS: ONLINE  |  MODE: ROOT ACCESS   ║\033[0m"
    echo -e "\033[1;32m╚══════════════════════════════════════════╝\033[0m"
    show_info_box
}

# Kelola User Langsung Merekam ke Dalam File Bash.sh Sendiri
manage_users() {
    clear
    show_header
    tput cnorm 2>/dev/null || true

    echo -e "\033[1;33m╔══════════════════════════════════════════╗\033[0m"
    echo -e "\033[1;33m║         KONFIGURASI USER INTERNAL        ║\033[0m"
    echo -e "\033[1;33m╚══════════════════════════════════════════╝\033[0m"
    echo -e "Daftar User Terdaftar:"
    local count=1
    for u in "${!USERS_DATA[@]}"; do
        echo -e "  \033[1;36m$count.\033[0m Username: \033[1;32m$u\033[0m"
        ((count++))
    done
    echo ""
    echo -e "\033[1;37mFormat input: \033[1;33mUsername:Password\033[0m (Contoh: \033[1;32mRanz:112\033[0m)"
    read -p "Masukkan User Baru / Ubah Pass : "Nano:root" , "Ranz:112"

    if [[ "$input_user_data" == *":"* ]]; then
        local new_user="${input_user_data%%:*}"
        local new_pass="${input_user_data#*:}"

        if [[ -z "$new_user" || -z "$new_pass" ]]; then
            echo -e "\n\033[1;31m[!] Format salah! Username dan Password tidak boleh kosong.\033[0m"
            sleep 2
            return
        fi

        USERS_DATA["$new_user"]="$new_pass"

        # Buat blok USER_LIST baru
        local new_list_str="USER_LIST=(\n"
        for u in "${!USERS_DATA[@]}"; do
            new_list_str+="    \"${u}:${USERS_DATA[$u]}\"\n"
        done
        new_list_str+=")"

        # Tulis ulang array USER_LIST secara otomatis di dalam file Bash.sh
        local script_path="$0"
        if [ -f "$script_path" ]; then
            awk -v new_block="$new_list_str" '
                /^USER_LIST=\(/ { print new_block; flag=1; next }
                flag && /^\)/ { flag=0; next }
                !flag { print }
            ' "$script_path" > "${script_path}.tmp" && mv "${script_path}.tmp" "$script_path"
            chmod +x "$script_path"
        fi

        echo -e "\n\033[1;32m[✓] Berhasil menyimpan user '$new_user' langsung ke Bash.sh!\033[0m"
        load_users
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

    load_users

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

# Hapus file eksternal lama jika masih ada
rm -f "$HOME/.env" "$HOME/config.sh" "./config.sh" 2>/dev/null

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
    echo -e "\033[1;36m║  3. Konfigurasi User                     ║\033[0m"
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
