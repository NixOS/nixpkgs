{
  stdenv,
  lib,
  rustPlatform,
  pkg-config,
  nix-update-script,
  fetchFromGitHub,
  IOKit,
  Foundation,
}:

rustPlatform.buildRustPackage rec {
  pname = "nushell_plugin_units";
  version = "0.1.3";

  src = fetchFromGitHub {
    repo = "nu_plugin_units";
    owner = "JosephTLyons";
    rev = "v${version}";
    hash = "sha256-zPN18ECzh2/l0kxp+Vyp3d9kCq3at/7SqMYbV3WDV3I=";
  };
  cargoHash = "sha256-6NWyuErdxj7//wW4L7ijW4RiWqdwbeTrelIjpisAGkg=";

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.cc.isClang [ rustPlatform.bindgenHook ];
  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    IOKit
    Foundation
  ];
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
