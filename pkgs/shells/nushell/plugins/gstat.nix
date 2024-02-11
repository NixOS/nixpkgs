{ stdenv
, lib
, rustPlatform
, openssl
, nushell
, pkg-config
, Security
, libclang
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "nushell_plugin_gstat";
  inherit (nushell) version src;
  cargoHash = "sha256-YUr//URKoN99Pc5tJx9eGopKqy4Yu83jPBhLu5UYgiY=";

  env = lib.optionalAttrs stdenv.cc.isClang {
    LIBCLANG_PATH = "${libclang.lib}/lib";
  };
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];
  cargoBuildFlags = [ "--package nu_plugin_gstat" ];

  checkPhase = ''
    cargo test --manifest-path crates/nu_plugin_gstat/Cargo.toml
  '';

  passthru.updateScript = nix-update-script {
    # Skip the version check and only check the hash because we inherit version from nushell.
    extraArgs = [ "--version=skip" ];
  };

  meta = with lib; {
    description = "A git status plugin for Nushell";
    homepage = "https://github.com/nushell/nushell/tree/${version}/crates/nu_plugin_gstat";
    license = licenses.mpl20;
    maintainers = with maintainers; [ mrkkrp aidalgol ];
    platforms = with platforms; all;
  };
}
