{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, zstd
, stdenv
, curl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-deny";
  version = "0.13.7";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = pname;
    rev = version;
    sha256 = "sha256-E9tFzac6WkEGfsXj1nykQAR20+5Pi5xMd82MeDed9qg=";
  };

  # enable pkg-config feature of zstd
  cargoPatches = [ ./zstd-pkg-config.patch ];

  cargoSha256 = "sha256-E3Gg7PwBNVkvX2vqtbCxz0kbe1ZWrcAWxj6OJtENBe0=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl zstd ]
    ++ lib.optionals stdenv.isDarwin [ curl Security ];

  buildNoDefaultFeatures = true;

  # tests require internet access
  doCheck = false;

  meta = with lib; {
    description = "Cargo plugin to generate list of all licenses for a crate";
    homepage = "https://github.com/EmbarkStudios/cargo-deny";
    changelog = "https://github.com/EmbarkStudios/cargo-deny/blob/${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda matthiasbeyer jk ];
  };
}
