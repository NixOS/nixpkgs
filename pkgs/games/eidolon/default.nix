{ lib, fetchgit, rustPlatform, pkg-config, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "eidolon";
  version = "1.4.6";

  src = fetchgit {
    url = "https://git.sr.ht/~nicohman/eidolon";
    rev = version;
    sha256 = "1yn3k569pxzw43mmsk97088xpkdc714rks3ncchbb6ccx25kgxrr";
  };
  cargoPatches = [ ./cargo-lock.patch ];

  cargoSha256 = "14dwb22cylacqpf5ym2fyv6zyhj5pm6kfzqdwhcg7z9h70501kp0";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  meta = with lib; {
    description = "A single TUI-based registry for drm-free, wine and steam games on linux, accessed through a rofi launch menu";
    homepage = "https://github.com/nicohman/eidolon";
    license = licenses.gpl3;
    maintainers = with maintainers; [ _0x4A6F ];
    platforms = platforms.linux;
  };
}
