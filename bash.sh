cat << 'EOF' > Bash.sh
#!/data/data/com.termux/files/usr/bin/bash
# =========================================================
# LINUX ROOT ENVIRONMENT FOR TERMUX - SINGLE FILE VERSION
# =========================================================

# >>> USERLIST BEGIN  (JANGAN HAPUS MARKER INI)
USER_LIST=(
    "Ranz:123"
    "Raizdev:112"
    "Nano:root"
)
# >>> USERLIST END  (JANGAN HAPUS MARKER INI)

declare -A USERS_DATA

tput civis 2>/dev/null || true

# ── Load user dari array internal ──
load_users() {
    USERS_DATA=()
    for entry in "${USER_LIST[@]}"; do
        [[ "$entry" == *":"* ]] || continue
        local u_name="${entry%%:*}"
        local u_pass="${entry#*:}"
        [[ -z "$u_name" || -z "$u_pass" ]] && continue
        USERS_DATA["$u_name"]="$u_pass"
    done
    if [ ${#USERS_DATA[@]} -eq 0 ]; then
        USERS_DATA["Ranz"]="123"
    fi
}

load_users

# ── Logo Tux ASCII ──
show_logo() {
    clear
    local logo=(
        "\033[31m         .---.         \033[0m"
        "\033[31m        /     \\        \033[0m"
        "\033[31m       |       |       \033[0m"
        "\033[31m      / \033[30;47m-     -\033[0m\033[31m \\      \033[0m"
        "\033[31m     |   \033[33m(o) (o)\033[0m\033[31m |     \033[0m"
        "\033[31m     |  \033[33m  .---.\033[0m \033[31m |     \033[0m"
        "\033[31m     | \033[33m  /     \\\\\033[0m\033[31m|     \033[0m"
        "\033[31m     | \033[33m  \\___/ \033[0m\033[31m|     \033[0m"
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

# ── Kotak info sistem ──
show_info_box() {
    local current_time=$(date +"%H:%M:%S WIB - %d/%m/%Y")
    local total_users=${#USERS_DATA[@]}
    echo -e "\033[1;36m╔══════════════════════════════════════════╗\033[0m"
    echo -e "\033[1;36m║\033[0m \033[1;33mSYSTEM INFORMATION STATUS\033[0m                \033[1;36m║\033[0m"
    echo -e "\033[1;36m╠══════════════════════════════════════════╣\033[0m"
    printf "\033[1;36m║\033[0m \033[1;37m%-13s :\033[0m \033[1;32m%-22s\033[0m \033[1;36m║\033[0m\n" "Registered" "$total_users User(s)"
    printf "\033[1;36m║\033[0m \033[1;37m%-13s :\033[0m \033[1;35m%-22s\033[0m \033[1;36m║\033[0m\n" "Time / Date" "$current_time"
    echo -e "\033[1;36m╚══════════════════════════════════════════╝\033[0m"
    echo ""
}

# ── Loading bar ──
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

# ── Header utama ──
show_header() {
    clear
    load_users
    echo -e "\033[1;32m╔══════════════════════════════════════════╗\033[0m"
    echo -e "\033[1;32m║   WELCOME TO LINUX ROOT ENVIRONMENT      ║\033[0m"
    echo -e "\033[1;32m║   STATUS: ONLINE  |  MODE: ROOT ACCESS   ║\033[0m"
    echo -e "\033[1;32m╚══════════════════════════════════════════╝\033[0m"
    show_info_box
}

# ── Rewrite blok USER_LIST di file Bash.sh sendiri ──
rewrite_userlist() {
    local sp="$1"
    [ -f "$sp" ] || { echo "Script path tidak ditemukan"; return 1; }
    local tmp="${sp}.tmp"

    {
        # Cetak semua baris sampai (termasuk) marker BEGIN
        sed -n '1,/^# >>> USERLIST BEGIN/p' "$sp"
        # Array baru
        echo "USER_LIST=("
        for u in "${!USERS_DATA[@]}"; do
            printf '    "%s:%s"\n' "$u" "${USERS_DATA[$u]}"
        done
        echo ")"
        # Cetak dari marker END sampai akhir file
        sed -n '/^# >>> USERLIST END/,$p' "$sp"
    } > "$tmp"

    mv "$tmp" "$sp" && chmod +x "$sp"
    return 0
}

# ── Menu konfigurasi user ──
manage_users() {
    clear
    show_header
    tput cnorm 2>/dev/null || true

    echo -e "\033[1;33m╔══════════════════════════════════════════╗\033[0m"
    echo -e "\033[1;33m║         KONFIGURASI USER INTERNAL        ║\033[0m"
    echo -e "\033[1;33m╚══════════════════════════════════════════╝\033[0m"

    echo -e "\033[1;37mUser terdaftar saat ini:\033[0m"
    local count=1
    for u in "${!USERS_DATA[@]}"; do
        printf "  \033[1;36m%d.\033[0m \033[1;32m%-15s\033[0m  (pass: \033[1;33m%s\033[0m)\n" \
            "$count" "$u" "${USERS_DATA[$u]}"
        ((count++))
    done
    echo ""

    echo -e "\033[1;36m┌─ PETUNJUK ───────────────────────────────┐\033[0m"
    echo -e "\033[1;36m│\033[0m Format   : \033[1;33musername:password\033[0m              \033[1;36m│\033[0m"
    echo -e "\033[1;36m│\033[0m Contoh   : \033[1;32mRanz:112\033[0m                       \033[1;36m│\033[0m"
    echo -e "\033[1;36m│\033[0m Tambah banyak sekaligus, pisah koma    \033[1;36m│\033[0m"
    echo -e "\033[1;36m│\033[0m Contoh   : \033[1;32mBudi:abc, Siti:xyz\033[0m             \033[1;36m│\033[0m"
    echo -e "\033[1;36m│\033[0m Ubah pass: tulis ulang user yang sama   \033[1;36m│\033[0m"
    echo -e "\033[1;36m│\033[0m Kosong   : tekan Enter buat batal       \033[1;36m│\033[0m"
    echo -e "\033[1;36m└─────────────────────────────────────────┘\033[0m"
    echo ""

    read -p "$(echo -e "\033[1;33mInput > \033[0m")" input_user_data

    if [ -z "$input_user_data" ]; then
        echo -e "\n\033[1;31m[!] Dibatalkan.\033[0m"
        sleep 1
        return
    fi

    local added=0
    local failed=0

    # Pisah input dengan koma
    IFS=',' read -ra ENTRIES <<< "$input_user_data"
    for entry in "${ENTRIES[@]}"; do
        # Trim spasi
        entry="$(echo "$entry" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
        [ -z "$entry" ] && continue

        if [[ "$entry" != *":"* ]]; then
            echo -e "\033[1;31m[!] '$entry' tidak ada tanda ':'. Skip.\033[0m"
            ((failed++))
            continue
        fi

        local new_user="${entry%%:*}"
        local new_pass="${entry#*:}"

        if [ -z "$new_user" ] || [ -z "$new_pass" ]; then
            echo -e "\033[1;31m[!] '$entry' username/password kosong. Skip.\033[0m"
            ((failed++))
            continue
        fi

        USERS_DATA["$new_user"]="$new_pass"
        echo -e "\033[1;32m  ✓ '$new_user' ditambahkan / diubah\033[0m"
        ((added++))
    done

    if [ "$added" -eq 0 ]; then
        echo -e "\n\033[1;31m[!] Tidak ada user valid yang ditambahkan.\033[0m"
        sleep 2
        return
    fi

    # Tulis ulang ke Bash.sh
    if rewrite_userlist "$0"; then
        echo -e "\n\033[1;32m[✓] $added user tersimpan ke Bash.sh\033[0m"
        [ "$failed" -gt 0 ] && echo -e "\033[1;33m[!] $failed entri gagal dilewati\033[0m"
    else
        echo -e "\n\033[1;31m[!] Gagal menulis ulang file Bash.sh\033[0m"
    fi

    load_users
    sleep 2
}

# ── Terminal login ──
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

        # Tulis rcfile ke /tmp biar gak pakai process substitution
        local rc="/tmp/ranz_rc_$$"
        cat > "$rc" <<RCEOF
export PS1="\[\033[38;5;196m\]root{${input_user}}\[\033[0m\]\[\033[38;5;51m\] \w\[\033[0m\]# "
alias help='echo "Command: ls cd pwd cat echo exit"'
RCEOF
        bash --rcfile "$rc" -i
        rm -f "$rc"
    else
        echo -e "\n\033[1;31m[!] Username atau Password Salah!\033[0m"
        sleep 2
    fi
}

# ── Bersihkan file lama ──
rm -f "$HOME/.env" "$HOME/config.sh" "./config.sh" 2>/dev/null

# ── Animasi awal ──
show_logo
show_info_box
show_loading

# ── Menu utama ──
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
