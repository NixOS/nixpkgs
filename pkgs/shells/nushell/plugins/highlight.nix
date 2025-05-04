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
  version = "1.4.5+0.104.0";

  src = fetchFromGitHub {
    repo = "nu-plugin-highlight";
    owner = "cptpiepmatz";
    rev = "refs/tags/v${version}";
    hash = "sha256-B2CkdftlxczA6KHJsNmbPH7Grzq4MG7r6CRMvVTMkzQ=";
    fetchSubmodules = true;
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-3bLATtK9r4iVpxdbg5eCvzeGpIqWMl/GTDGCORuQfgY=";

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
