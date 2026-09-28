# Vir's Server: modpack

Mod untuk main di server ini (alamat **163.52.135.197**): Minecraft 1.21.1 dengan
NeoForge 21.1.251. Daftar ini ditulis oleh panel server setiap kali modnya
berubah, jadi selalu sama dengan yang dipakai server.

## TLauncher

1. Unduh repo ini: tombol hijau **Code**, lalu **Download ZIP**. Ekstrak ke folder mana saja.
2. Di TLauncher, pilih versi **1.21.1-NeoForge**, jalankan sekali sampai menu utama,
   lalu tutup.
3. Klik dua kali **Update-Mods.bat**. Mod yang kurang diunduh, yang berubah diperbarui, dan yang
   sudah tidak dipakai dihapus. Saat pertama kali, mod lain yang sudah ada di folder mods
   dipindah ke folder `mods-backup-...`, tidak dihapus.
4. Jalankan **Update-Mods.bat** lagi setiap mau main. Kalau tidak ada yang berubah, selesai
   dalam beberapa detik.

Kalau Windows menampilkan "Windows protected your PC", pilih **More info** lalu **Run anyway**.
Skripnya hanya mengunduh dari `cdn.modrinth.com` dan mengecek setiap file sebelum dipakai.

Atur RAM di TLauncher minimal 4 GB, disarankan 5 sampai 6 GB.

## Prism Launcher (otomatis tiap Play)

1. Buat instance baru: Minecraft **1.21.1**, loader **NeoForge 21.1.251**.
2. Unduh `packwiz-installer-bootstrap.jar` dari
   https://github.com/packwiz/packwiz-installer-bootstrap/releases/latest dan taruh di folder
   `minecraft` instance itu (klik kanan instance, **Folder**).
3. **Edit** instance, **Settings**, **Custom commands**, centang, lalu isi *Pre-launch command*:

   ```
   "$INST_JAVA" -jar packwiz-installer-bootstrap.jar https://raw.githubusercontent.com/naufaleko/vir-server-modpack/main/pack.toml
   ```

Setiap kali menekan Play, mod disamakan dulu dengan daftar ini.

## Daftar mod (12)

| Mod | Versi | Untuk |
|---|---|---|
| AppleSkin | 3.0.9+mc1.21 | klien saja |
| Create | 6.0.10+mc1.21.1 | server dan klien |
| Create Aeronautics | 1.3.2+mc1.21.1 | server dan klien |
| FerriteCore | 7.0.3-neoforge | server dan klien |
| Jade 🔍 | 15.10.6+neoforge | server dan klien |
| Just Enough Items (JEI) | 19.51.0.418 | server dan klien |
| Lithium | mc1.21.1-0.15.4-neoforge | server dan klien |
| ModernFix | 5.27.24+mc1.21.1 | server dan klien |
| Mouse Tweaks | 1.21-2.26.1-neoforge | klien saja |
| Sable | 2.0.5+mc1.21.1 | server dan klien |
| Sodium | mc1.21.1-0.8.13-neoforge | klien saja |
| spark | 1.10.124-neoforge-1.21.1 | server dan klien |
