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
  version = "0.17.3";

  src = fetchFromGitHub {
    owner = "boa-dev";
    repo = "boa";
    rev = "v${version}";
    hash = "sha256-ROzdOanfHNPwHXA0SzU2fpuBonbDbgDqH+ZgOjwK/tg=";
    fetchSubmodules = true;
  };

  patches = [
    (fetchpatch {
      name = "fix-rust-1.71-lints.patch";
      url = "https://github.com/boa-dev/boa/commit/93d05bda6864aa6ee67682d84bd4fc2108093ef5.patch";
      hash = "sha256-hMp4/UBN5moGBSqf8BJV2nBwgV3cry9uC2fJmdT5hkQ=";
    })
  ];

  cargoHash = "sha256-UIUXayJwTrWbLm1UKnIXy1Df8a7ZoBzdNm/uZ1+H+SQ=";

  cargoBuildFlags = [ "--package" "boa_cli" ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [ bzip2 openssl zstd ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.CoreFoundation
      darwin.apple_sdk.frameworks.Security
    ];

  env = { ZSTD_SYS_USE_PKG_CONFIG = true; };

  meta = with lib; {
    description = "Embeddable and experimental Javascript engine written in Rust";
    mainProgram = "boa";
    homepage = "https://github.com/boa-dev/boa";
    changelog = "https://github.com/boa-dev/boa/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ mit /* or */ unlicense ];
    maintainers = with maintainers; [ dit7ya ];
  };
}
