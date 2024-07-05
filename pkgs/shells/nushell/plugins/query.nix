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
  inherit (nushell) version src;
  cargoHash = "sha256-zFkq+rx1GN6TQvm5jK8O2ocR0pUbtVFk051IlwCu100=";

  nativeBuildInputs = lib.optionals stdenv.cc.isClang [ rustPlatform.bindgenHook ];
  buildInputs = lib.optionals stdenv.isDarwin [ IOKit CoreFoundation ];
  cargoBuildFlags = [ "--package nu_plugin_query" ];

  checkPhase = ''
    cargo test --manifest-path crates/nu_plugin_query/Cargo.toml
  '';

  passthru.updateScript = nix-update-script {
    # Skip the version check and only check the hash because we inherit version from nushell.
    extraArgs = [ "--version=skip" ];
  };

  meta = with lib; {
    description = "Nushell plugin to query JSON, XML, and various web data";
    mainProgram = "nu_plugin_query";
    homepage = "https://github.com/nushell/nushell/tree/${version}/crates/nu_plugin_query";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada aidalgol ];
    platforms = with platforms; all;
  };
}
