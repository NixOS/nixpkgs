{ stdenv, fetchgit, rustPlatform, pkgconfig, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "eidolon";
  version = "1.4.6";

  src = fetchgit {
    url = "https://git.sr.ht/~nicohman/eidolon";
    rev = "${version}";
    sha256 = "1yn3k569pxzw43mmsk97088xpkdc714rks3ncchbb6ccx25kgxrr";
  };
  cargoPatches = [ ./cargo-lock.patch ];

  cargoSha256 = "1i8qfphynwi42pkhhgllxq42dnw9f0dd6f829z94a3g91czyqvsw";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl ];

  meta = with stdenv.lib; {
    description = "A single TUI-based registry for drm-free, wine and steam games on linux, accessed through a rofi launch menu";
    homepage = "https://github.com/nicohman/eidolon";
    license = licenses.gpl3;
    maintainers = [ maintainers."0x4A6F" ];
    platforms = platforms.linux;
  };
}
