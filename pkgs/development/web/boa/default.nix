{ lib
, rustPlatform
, fetchFromGitHub
, fetchpatch
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

  patches = [
    (fetchpatch {
      name = "fix-rust-1.71-lints.patch";
      url = "https://github.com/boa-dev/boa/commit/93d05bda6864aa6ee67682d84bd4fc2108093ef5.patch";
      hash = "sha256-hMp4/UBN5moGBSqf8BJV2nBwgV3cry9uC2fJmdT5hkQ=";
    })
  ];

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
