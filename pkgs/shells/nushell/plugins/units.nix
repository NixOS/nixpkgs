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
  version = "0.1.4";

  src = fetchFromGitHub {
    repo = "nu_plugin_units";
    owner = "JosephTLyons";
    rev = "v${version}";
    hash = "sha256-iDRrA8bvufV92ADeG+eF3xu7I/4IinJcSxEkwuhkHlg=";
  };
  cargoHash = "sha256-if8uvDRwr6p5VENdls9mIfECiu/zDybcpkphZLHRHe8=";

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
