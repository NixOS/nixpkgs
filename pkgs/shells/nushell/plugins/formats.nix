{ stdenv
, lib
, rustPlatform
, nushell
, pkg-config
, IOKit
, Foundation
}:

rustPlatform.buildRustPackage {
  pname = "nushell_plugin_formats";
  version = "0.85.0";
  src = nushell.src;
  cargoHash = "sha256-WS8VRpJnn/VWS7GUkGowFf51ifUx0SbEZzcoTfx2dp0=";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = lib.optionals stdenv.isDarwin [ IOKit Foundation ];
  cargoBuildFlags = [ "--package nu_plugin_formats" ];
  checkPhase = ''
    cargo test --manifest-path crates/nu_plugin_formats/Cargo.toml
  '';
  meta = with lib; {
    description = "A formats plugin for Nushell";
    homepage = "https://github.com/nushell/nushell/tree/${version}/crates/nu_plugin_formats";
    license = licenses.mpl20;
    maintainers = with maintainers; [ viraptor ];
    platforms = with platforms; all;
  };
}
