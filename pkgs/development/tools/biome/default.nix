{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2_1_6
, zlib
, stdenv
, darwin
, git
}:

rustPlatform.buildRustPackage rec {
  pname = "biome";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "biomejs";
    repo = "biome";
    rev = "cli/v${version}";
    hash = "sha256-oX/LyC6JN0NUc/xi4G9lzKgF9yOlooAt69Gw+eLJxbE=";
  };

  cargoHash = "sha256-4P57fmp5CpGn1wYkQos7PO3YFChup8LrrLExv9S76gs=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2_1_6
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  nativeCheckInputs = [
    git
  ];

  cargoBuildFlags = [ "-p=rome_cli" ];
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
