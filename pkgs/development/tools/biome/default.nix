{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2_1_6
, rust-jemalloc-sys
, zlib
, stdenv
, darwin
, git
}:

rustPlatform.buildRustPackage rec {
  pname = "biome";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "biomejs";
    repo = "biome";
    rev = "cli/v${version}";
    hash = "sha256-0xLpZIqBaM4hTWsJzkVZMuDySFSXCLpQm/maCaXDJQo=";
  };

  cargoHash = "sha256-wf6X6aY1O9EABQ6sDNAb3XsVrC0lgUtpgoieiPZ7r3k=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2_1_6
    rust-jemalloc-sys
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  nativeCheckInputs = [
    git
  ];

  cargoBuildFlags = [ "-p=biome_cli" ];
  cargoTestFlags = cargoBuildFlags;

  env = {
    BIOME_VERSION = version;
  };

  preCheck = ''
    # tests assume git repository
    git init

    # tests assume $BIOME_VERSION is unset
    unset BIOME_VERSION
  '';

  meta = with lib; {
    description = "Toolchain of the web";
    homepage = "https://biomejs.dev/";
    changelog = "https://github.com/biomejs/biome/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "biome";
  };
}
