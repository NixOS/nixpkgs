{ stdenv
, lib
, rustPlatform
, nushell
, nix-update-script
, IOKit
, CoreFoundation
}:

let
  pname = "nushell_plugin_query";
in
rustPlatform.buildRustPackage {
  inherit pname;
  version = nushell.version;

  src = nushell.src;

  cargoHash = "sha256-BKeEAgvhHP01K/q8itwFfFIH8BAS9e1dat449i3M4ig=";

  buildInputs = lib.optionals stdenv.isDarwin [ IOKit CoreFoundation ];

  cargoBuildFlags = [ "--package nu_plugin_query" ];

  # compilation fails with a missing symbol
  doCheck = false;

  meta = with lib; {
    description = "A Nushell plugin to query JSON, XML, and various web data";
    homepage = "https://github.com/nushell/nushell/tree/main/crates/nu_plugin_query";
    license = licenses.mpl20;
    maintainers = with maintainers; [ happysalada ];
    platforms = with platforms; all;
  };
}
