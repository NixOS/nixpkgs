{ stdenv
, lib
, rustPlatform
, nushell
, IOKit
, CoreFoundation
}:

rustPlatform.buildRustPackage {
  pname = "nushell_plugin_query";
  version = "0.80.0";

  src = nushell.src;

  cargoHash = "sha256-k4UjHNf5L9RmYuB66gcoyCmhd1MvtAxTOxRh24sv0sk=";

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
