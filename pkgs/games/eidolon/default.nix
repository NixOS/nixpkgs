{ lib, fetchFromSourcehut, rustPlatform, pkg-config, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "eidolon";
  version = "1.4.6";

  src = fetchFromSourcehut {
    owner = "~nicohman";
    repo = pname;
    rev = version;
    sha256 = "1yn3k569pxzw43mmsk97088xpkdc714rks3ncchbb6ccx25kgxrr";
  };
  cargoPatches = [ ./cargo-lock.patch ];

  cargoSha256 = "01mnfn6j4sj9iqw5anpx8lqm9jmk7wdrx3h2hcvqcmkyrk1nggx0";

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
