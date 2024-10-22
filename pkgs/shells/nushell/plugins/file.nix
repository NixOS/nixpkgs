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
  version = "0.9.0";

  src = fetchFromGitHub {
    repo = "nu_plugin_file";
    owner = "fdncred";
    rev = "refs/tags/v${version}";
    hash = "sha256-2dSdNC89D1IJgbUq+S5FN8ue5BJNOs8exzlYB0Jqj1w=";
  };
  cargoHash = "sha256-2k/C/X3yjdb9woXQCipWh1jaQ/GNZ/KRhnByD48R7rY=";

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

  meta = with lib; {
    description = "A nushell plugin that will inspect a file and return information based on it's magic number.";
    mainProgram = "nu_plugin_file";
    homepage = "https://github.com/fdncred/nu_plugin_file";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ mgttlinger ];
    platforms = with platforms; all;
  };
}
