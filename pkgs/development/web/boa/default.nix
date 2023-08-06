{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, bzip2
, openssl
, zstd
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "boa";
  version = "0.17";

  src = fetchFromGitHub {
    owner = "boa-dev";
    repo = "boa";
    rev = "v${version}";
    hash = "sha256-3Iv7Ko6ukbmec4yDKayxW0T6+3ZNbUT4wWwEarBy4Zs=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-2ZzTvVoA4oxy26rL0tvdvXm2oVWpHP+gooyjB4vIP3M=";

  cargoBuildFlags = [ "--package" "boa_cli" ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [ bzip2 openssl zstd ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.CoreFoundation
      darwin.apple_sdk.frameworks.Security
    ];

  env = { ZSTD_SYS_USE_PKG_CONFIG = true; };

  meta = with lib; {
    description = "An embeddable and experimental Javascript engine written in Rust";
    homepage = "https://github.com/boa-dev/boa";
    changelog = "https://github.com/boa-dev/boa/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ mit /* or */ unlicense ];
    maintainers = with maintainers; [ dit7ya ];
  };
}
