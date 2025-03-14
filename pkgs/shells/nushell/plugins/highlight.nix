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
  version = "1.4.3+0.102.0";

  src = fetchFromGitHub {
    repo = "nu-plugin-highlight";
    owner = "cptpiepmatz";
    rev = "refs/tags/v${version}";
    hash = "sha256-0gKwk5YGysKWAFZdUAWzw3wiCvzF43N9f5Bj5NnDTJ4=";
    fetchSubmodules = true;
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Z7fTKMZacNTRrcwJNb8kiH5G8irITQMNpt+pcskDbKQ=";

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
