{
  stdenv,
  lib,
  rustPlatform,
  pkg-config,
  nix-update-script,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "nushell_plugin_units";
  version = "0.1.6";

  src = fetchFromGitHub {
    repo = "nu_plugin_units";
    owner = "JosephTLyons";
    rev = "v${version}";
    hash = "sha256-1KyuUaWN+OiGpo8Ohc/8B+nisdb8uT+T3qBu+JbaVYo=";
  };
  useFetchCargoVendor = true;
  cargoHash = "sha256-LYVwFM8znN96LwOwRnauehrucSqHnKNPoMzl2HRczww=";

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.cc.isClang [ rustPlatform.bindgenHook ];
  cargoBuildFlags = [ "--package nu_plugin_units" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A nushell plugin for easily converting between common units.";
    mainProgram = "nu_plugin_units";
    homepage = "https://github.com/JosephTLyons/nu_plugin_units";
    license = licenses.mit;
    maintainers = with maintainers; [ mgttlinger ];
    platforms = with platforms; all;
  };
}
