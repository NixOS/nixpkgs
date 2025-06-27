{
  stdenv,
  lib,
  rustPlatform,
  pkg-config,
  nix-update-script,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nushell_plugin_highlight";
  version = "1.4.5+0.104.0";

  src = fetchFromGitHub {
    owner = "cptpiepmatz";
    repo = "nu-plugin-highlight";
    tag = "v${finalAttrs.version}";
    hash = "sha256-B2CkdftlxczA6KHJsNmbPH7Grzq4MG7r6CRMvVTMkzQ=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-3bLATtK9r4iVpxdbg5eCvzeGpIqWMl/GTDGCORuQfgY=";

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.cc.isClang [ rustPlatform.bindgenHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A nushell plugin for syntax highlighting.";
    mainProgram = "nu_plugin_highlight";
    homepage = "https://github.com/cptpiepmatz/nu-plugin-highlight";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mgttlinger ];
  };
})
