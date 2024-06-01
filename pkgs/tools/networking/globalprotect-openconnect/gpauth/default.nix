{
  callPackage,
  libsoup,
  openssl,
  pkg-config,
  perl,
  webkitgtk,
}:
let
  common = opts: callPackage (import ../common.nix opts) { };
in
common {
  pname = "gpauth";
  buildAndTestSubdir = "apps/gpauth";
  cargoHash = "sha256-Fqu5S8rXnQkSGvUZnbjQt4zJGTV8ZJytTg9YRwkpwCA=";

  nativeBuildInputs = [
    perl
    pkg-config
  ];
  buildInputs = [
    libsoup
    openssl
    webkitgtk
  ];
}
