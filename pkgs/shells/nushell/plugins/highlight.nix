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
  pname = "nushell_plugin_highlight";
  version = "1.4.4+0.103.0";

  src = fetchFromGitHub {
    repo = "nu-plugin-highlight";
    owner = "cptpiepmatz";
    rev = "refs/tags/v${version}";
    hash = "sha256-XxYsxoHeRhZ4A52ctyJZVqJ40J3M3R42NUetZZIbk0w=";
    fetchSubmodules = true;
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-y0SCpDU1GM5JrixOffP1DRGtaXZsBjr7fYgYxhn4NDg=";

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.cc.isClang [ rustPlatform.bindgenHook ];
  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    IOKit
    Foundation
  ];
  cargoBuildFlags = [ "--package nu_plugin_highlight" ];

  checkPhase = ''
    cargo test
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A nushell plugin for syntax highlighting.";
    mainProgram = "nu_plugin_highlight";
    homepage = "https://github.com/cptpiepmatz/nu-plugin-highlight";
    license = licenses.mit;
    maintainers = with maintainers; [ mgttlinger ];
    platforms = with platforms; all;
  };
}
