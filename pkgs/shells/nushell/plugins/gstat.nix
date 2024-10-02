{
  stdenv,
  lib,
  rustPlatform,
  openssl,
  nushell,
  pkg-config,
  Security,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "nushell_plugin_gstat";
  inherit (nushell) version src;
  cargoHash = "sha256-NLGEaIGUqgyGegzVyZloLckVGYmfMjwhzVXh327kxRA=";

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.cc.isClang [ rustPlatform.bindgenHook ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ Security ];
  cargoBuildFlags = [ "--package nu_plugin_gstat" ];

  checkPhase = ''
    cargo test --manifest-path crates/nu_plugin_gstat/Cargo.toml
  '';

  passthru.updateScript = nix-update-script {
    # Skip the version check and only check the hash because we inherit version from nushell.
    extraArgs = [ "--version=skip" ];
  };

  meta = with lib; {
    description = "Git status plugin for Nushell";
    mainProgram = "nu_plugin_gstat";
    homepage = "https://github.com/nushell/nushell/tree/${version}/crates/nu_plugin_gstat";
    license = licenses.mit;
    maintainers = with maintainers; [
      mrkkrp
      aidalgol
    ];
    platforms = with platforms; all;
  };
}
