{
  stdenv,
  lib,
  rustPlatform,
  nushell,
  nix-update-script,
  pkg-config,
  openssl,
  curl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_query";
  inherit (nushell) version src cargoHash;

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.cc.isClang [ rustPlatform.bindgenHook ];
  buildInputs = [
    openssl
    curl
  ];

  buildAndTestSubdir = "crates/nu_plugin_query";

  passthru.updateScript = nix-update-script {
    # Skip the version check and only check the hash because we inherit version from nushell.
    extraArgs = [ "--version=skip" ];
  };

  meta = {
    description = "Nushell plugin to query JSON, XML, and various web data";
    mainProgram = "nu_plugin_query";
    homepage = "https://github.com/nushell/nushell/tree/${finalAttrs.version}/crates/nu_plugin_query";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      happysalada
    ];
  };
})
