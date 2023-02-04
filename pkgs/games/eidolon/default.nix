{
  lib,
  fetchFromSourcehut,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "eidolon";
  version = "1.4.6";

  src = fetchFromSourcehut {
    owner = "~nicohman";
    repo = pname;
    rev = version;
    sha256 = "sha256-Ofc3i+iMmbUgY3bomUk4rM3bEQInTV3rIPz3m0yZw/o=";
  };
  cargoPatches = [ ./cargo-lock.patch ];

  cargoSha256 = "sha256-1d+Wgx6tBS1Rb8WpVrD/ja0zXdoE2Q9ZlUS/3p8OYWM=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  OPENSSL_NO_VENDOR = 1;
  OPENSSL_LIB_DIR = "${lib.getLib openssl}/lib";
  OPENSSL_INCLUDE_DIR = "${openssl.dev}/include";
  OPENSSL_DIR="${lib.getDev openssl}";

  meta = with lib; {
    description = "A single TUI-based registry for drm-free, wine and steam games on linux, accessed through a rofi launch menu";
    homepage = "https://github.com/nicohman/eidolon";
    license = licenses.gpl3;
    maintainers = with maintainers; [ _0x4A6F ];
    platforms = platforms.linux;
  };
}
