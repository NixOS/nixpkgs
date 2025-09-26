{
  stdenv,
  lib,
  rustPlatform,
  pkg-config,
  nix-update-script,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_units";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "JosephTLyons";
    repo = "nu_plugin_units";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4donh0UlBbaEwgDxUECKTPWGLuAc9KUmrRty2Ob7ZMA=";
  };

  cargoHash = "sha256-8/ubL2s49y8mqXFJBs9gA0U889k8Bx6UfAy77jJx6TM=";

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.cc.isClang [ rustPlatform.bindgenHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Nushell plugin for easily converting between common units";
    mainProgram = "nu_plugin_units";
    homepage = "https://github.com/JosephTLyons/nu_plugin_units";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mgttlinger ];
  };
})
