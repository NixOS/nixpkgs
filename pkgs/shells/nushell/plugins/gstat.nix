{ stdenv
, lib
, rustPlatform
, openssl
, nushell
, pkg-config
}:

let
  pname = "nushell_plugin_gstat";
in
rustPlatform.buildRustPackage {
  inherit pname;
  version = "0.83.1";
  src = nushell.src;
  cargoHash = "sha256-qRKONc8rDRALEin8WGxi7Jma4uD+U+9Gu6zpmYWmGOc=";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];
  cargoBuildFlags = [ "--package nu_plugin_gstat" ];
  doCheck = false; # some tests fail
  meta = with lib; {
    description = "A git status plugin for Nushell";
    homepage = "https://github.com/nushell/nushell/tree/main/crates/nu_plugin_gstat";
    license = licenses.mpl20;
    maintainers = with maintainers; [ mrkkrp ];
    platforms = with platforms; all;
  };
}
