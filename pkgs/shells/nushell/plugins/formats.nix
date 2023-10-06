{ stdenv
, lib
, rustPlatform
, nushell
, pkg-config
, IOKit
, Foundation
}:

let
  pname = "nushell_plugin_formats";
in
rustPlatform.buildRustPackage {
  inherit pname;
  version = "0.85.0";
  src = nushell.src;
  cargoHash = "sha256-WS8VRpJnn/VWS7GUkGowFf51ifUx0SbEZzcoTfx2dp0=";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = lib.optionals stdenv.isDarwin [ IOKit Foundation ];
  cargoBuildFlags = [ "--package nu_plugin_formats" ];
  doCheck = false;
  meta = with lib; {
    description = "A formats plugin for Nushell";
    homepage = "https://github.com/nushell/nushell/tree/main/crates/nu_plugin_formats";
    license = licenses.mpl20;
    maintainers = with maintainers; [ viraptor ];
    platforms = with platforms; all;
  };
}
