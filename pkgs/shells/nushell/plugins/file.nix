{
  stdenv,
  lib,
  rustPlatform,
  pkg-config,
  nix-update-script,
  fetchFromGitHub,
  CoreFoundation,
  IOKit,
}:

rustPlatform.buildRustPackage rec {
  pname = "nushell_plugin_file";
  version = "0.11.0";

  src = fetchFromGitHub {
    repo = "nu_plugin_file";
    owner = "fdncred";
    rev = "refs/tags/v${version}";
    hash = "sha256-aG5lBrzOJiP7LO3Mxx/c1MG6uIgYjpFZWpz69xBItqY=";
  };
  cargoHash = "sha256-dD6b0i8lK7UQVEex4bnpzOvgBK+upXwyHl9Wlqq7Ess=";

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.cc.isClang [ rustPlatform.bindgenHook ];
  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    CoreFoundation
    IOKit
  ];
  cargoBuildFlags = [ "--package nu_plugin_file" ];

  checkPhase = ''
    cargo test
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A nushell plugin that will inspect a file and return information based on it's magic number.";
    mainProgram = "nu_plugin_file";
    homepage = "https://github.com/fdncred/nu_plugin_file";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.mgttlinger ];
    platforms = lib.platforms.all;
  };
}
