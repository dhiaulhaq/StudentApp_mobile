## Instalasi Aplikasi

- Setelah anda selesai clone atau download project, pastikan anda sudah menjalankan project [StudentApp_web](https://github.com/dhiaulhaq/StudentApp_web) pada server anda
- Jika sudah, buka project dan konfigurasikan Flutter SDK Path. Jika anda menggunakan Android Studio anda dapat melakukannya dengan membuka File -> Settings -> Language & Frameworks -> Flutter -> Flutter SDK Path
  ![Screenshot (21)](https://user-images.githubusercontent.com/19872458/153241690-01db36da-71fd-4364-b6ce-f5a21d4c7e39.png)
- Buka terminal atau cmd dan arahkan ke folder project
- Jalankan 'flutter clean'
- Jalankan 'flutter pub get'
- Jalankan 'flutter pub upgrade'
- Setelah itu salin url server yang sedang menjalankan project [StudentApp_web](https://github.com/dhiaulhaq/StudentApp_web)
- Paste url tersebut pada String _url di file lib/controller/api.dart
- Lakukan hal yang sama pada String url di file lib/screens/home.dart
- Jalankan project untuk menginstall aplikasi

## Screenshot Aplikasi

- Halaman Login
  ![Screenshot_20220209-214343](https://user-images.githubusercontent.com/19872458/153242992-fdea0ab5-1c41-4f9f-a5b8-ba4af19e37f0.png)

- Halaman Register
  ![Screenshot_20220209-214347](https://user-images.githubusercontent.com/19872458/153243091-dc64fdca-275f-48a5-aabc-55f12260b087.png)

- Halaman Home
  ![Screenshot_20220209-214410](https://user-images.githubusercontent.com/19872458/153243115-ae276c33-0bee-460f-804e-a4dc6107b848.png)
