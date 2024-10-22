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
  version = "0.13.0";

  src = fetchFromGitHub {
    repo = "nu_plugin_file";
    owner = "fdncred";
    tag = "v${version}";
    hash = "sha256-cMDkhNPIfkJb01fBSt2fCCdg/acdzak66qMRp0zuJzc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-s2Sw8NDVJZoZsnNeGGCXb64WFb3ivO9TxBYFcjLVOZI=";

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
    changelog = "https://github.com/fdncred/nu_plugin_file/releases/tag/v${version}/CHANGELOG.md";
  };
}
