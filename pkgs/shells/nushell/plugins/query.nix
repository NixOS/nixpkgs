{ stdenv
, lib
, rustPlatform
, nushell
, IOKit
, CoreFoundation
, nix-update-script
}:

rustPlatform.buildRustPackage {
  pname = "nushell_plugin_query";
  version = "0.85.0";

  src = nushell.src;

  cargoHash = "sha256-xyty3GfI+zNkuHs7LYHBctqXUHZ4/MNNcnnfYvI18do=";

  buildInputs = lib.optionals stdenv.isDarwin [ IOKit CoreFoundation ];

  cargoBuildFlags = [ "--package nu_plugin_query" ];

  # compilation fails with a missing symbol
  doCheck = false;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "A Nushell plugin to query JSON, XML, and various web data";
    homepage = "https://github.com/nushell/nushell/tree/main/crates/nu_plugin_query";
    license = licenses.mpl20;
    maintainers = with maintainers; [ happysalada ];
    platforms = with platforms; all;
  };
}
