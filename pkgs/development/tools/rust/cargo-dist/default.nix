{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
, pkg-config
, bzip2
, xz
, zstd
, stdenv
, darwin
, git
, rustup
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-dist";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "axodotdev";
    repo = "cargo-dist";
    rev = "v${version}";
    hash = "sha256-AyxC1YS1VvCBIS6lKDtT2zX3bhorF4G+qg+brm4tJm8=";
  };

  cargoHash = "sha256-kStLY/Hjj0DeisjXzw2BbmJalNljUP0ogBEXcoDX3FE=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    bzip2
    xz
    zstd
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  nativeCheckInputs = [
    git
    rustup
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  # remove tests that require internet access and a git repo
  postPatch = ''
    rm cargo-dist/tests/integration-tests.rs
    rm cargo-dist/tests/cli-tests.rs
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A tool for building final distributable artifacts and uploading them to an archive";
    homepage = "https://github.com/axodotdev/cargo-dist";
    changelog = "https://github.com/axodotdev/cargo-dist/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda matthiasbeyer mistydemeo ];
  };
}
