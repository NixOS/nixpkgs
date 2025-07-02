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
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "JosephTLyons";
    repo = "nu_plugin_units";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1KyuUaWN+OiGpo8Ohc/8B+nisdb8uT+T3qBu+JbaVYo=";
  };

  cargoHash = "sha256-LYVwFM8znN96LwOwRnauehrucSqHnKNPoMzl2HRczww=";

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.cc.isClang [ rustPlatform.bindgenHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Nushell plugin for easily converting between common units";
    mainProgram = "nu_plugin_units";
    homepage = "https://github.com/JosephTLyons/nu_plugin_units";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mgttlinger ];
    # "Plugin `units` is compiled for nushell version 0.104.0, which is not
    # compatible with version 0.105.1"
    broken = true;
  };
})
