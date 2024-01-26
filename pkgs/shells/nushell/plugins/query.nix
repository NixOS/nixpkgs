{ stdenv
, lib
, rustPlatform
, nushell
, IOKit
, CoreFoundation
, libclang
, nix-update-script
}:

rustPlatform.buildRustPackage {
  pname = "nushell_plugin_query";
  inherit (nushell) version src;
  cargoHash = "sha256-IAMfd76+Sx01d4axn3qcLvXZW6nxu0fjy9CvupUTHBM=";

  env = lib.optionalAttrs stdenv.cc.isClang {
    LIBCLANG_PATH = "${libclang.lib}/lib";
  };
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
    description = "A Nushell plugin to query JSON, XML, and various web data";
    homepage = "https://github.com/nushell/nushell/tree/${version}/crates/nu_plugin_query";
    license = licenses.mpl20;
    maintainers = with maintainers; [ happysalada aidalgol ];
    platforms = with platforms; all;
  };
}
