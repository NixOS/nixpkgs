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
  version = "0.1.2";

  src = fetchFromGitHub {
    repo = "nu_plugin_units";
    owner = "JosephTLyons";
    rev = "v${version}";
    hash = "sha256-PS16n4j/dg5/+RaliYA18bStNpAecv9aaY2YKXsgLWY=";
  };
  cargoHash = "sha256-pxA+6E5luFHq/N0K/8Xk2LapwDnPqDUEpTYqP/jcc3s=";

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
