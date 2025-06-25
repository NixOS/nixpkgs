{
  stdenv,
  lib,
  rustPlatform,
  pkg-config,
  nix-update-script,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "nushell_plugin_highlight";
  version = "1.4.7+0.105.1";

  src = fetchFromGitHub {
    repo = "nu-plugin-highlight";
    owner = "cptpiepmatz";
    rev = "refs/tags/v${version}";
    hash = "sha256-0jU0c2v3q3RXX/zZlwTBwAdO8HEaROFNV/F4GBFaMt0=";
    fetchSubmodules = true;
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-UD1IzegajAG13iAOERymDa10JbuhvORVZ8gHy9d6buE=";

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.cc.isClang [ rustPlatform.bindgenHook ];
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
