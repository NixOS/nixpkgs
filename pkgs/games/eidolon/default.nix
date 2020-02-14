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

  # Delete this on next update; see #79975 for details
  legacyCargoFetcher = true;

  cargoSha256 = "1887fjkk641cn6dpmyc5r3r2li61yw1nvfb0f2dp3169gycka15h";

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
