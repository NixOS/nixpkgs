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

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  postPatch = ''
    ln -sf ${./Cargo.lock} Cargo.lock
  '';

  meta = with lib; {
    description = "A single TUI-based registry for drm-free, wine and steam games on linux, accessed through a rofi launch menu";
    homepage = "https://github.com/nicohman/eidolon";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ _0x4A6F ];
    platforms = platforms.linux;
  };
}
