# 🐧 Ranz Mods Root Termux Environment

<p align="center">
  <img src="https://img.shields.io/badge/OS-Linux%20%2F%20Termux-brightgreen?style=for-the-badge&logo=linux" alt="OS">
  <img src="https://img.shields.io/badge/Shell-Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white" alt="Bash">
  <img src="https://img.shields.io/badge/Version-1.0.0-red?style=for-the-badge" alt="Version">
</p>

Ubah tampilan Termux standar Anda menjadi **Linux Root Environment** profesional dengan animasi unik, *loading bar* yang mulus, sistem otentikasi `.env` otomatis, dan indikator sistem *real-time*.

---

## 📜 Tentangnya & Riwayat Berdiri

> **Ranz Mods Root** secara resmi dirilis pada **1 Oktober 2026**.  
> Skrip ini dirancang khusus untuk memberikan pengalaman antarmuka ala *Hacker/Root Linux* bagi para pengguna Termux di Android tanpa mengorbankan fungsionalitas dan performa terminal dasar.

---

## 🔥 Fitur Utama

- 🎨 **Typing Animation Logo Tux:** Efek penulisan karakter demi karakter logo Linux saat skrip pertama kali dijalankan.
- ⏳ **Loading Bar Dynamic (Red-Black-Gray):** Progress bar 1–100% tanpa spam layar/scroll tambahan.
- 📦 **System Info Box:** Menampilkan statistik waktu *real-time* dan jumlah *user* aktif secara otomatis di bawah logo.
- 🔄 **Auto-Detect `.env` Sync:** Setiap kali file `.env` diperbarui, skrip secara otomatis mendeteksi perubahan *checksum* MD5 dan memuat ulang kredensial tanpa perlu restart Termux.
- 🔐 **Secure Terminal Login:** Sistem login interaktif yang mengamankan sesi terminal Termux.
- 💻 **Custom Root Shell Prompt:** Membuka terminal interaktif dengan format prompt `root{USERNAME} $` dan logo ASCII Linux di pojok kanan atas.

---

## 🛠️ Cara Instalasi

Jalankan perintah berikut di aplikasi Termux Anda:

```bash
# Update paket & install dependency
pkg update && pkg upgrade -y
pkg install git jq -y

# Clone repositori ini
git clone [https://github.com/USERNAME_GITHUB_ANDA/nama-repo.git](https://github.com/USERNAME_GITHUB_ANDA/nama-repo.git)
cd nama-repo

# Berikan izin eksekusi
chmod +x cool_termux.sh
