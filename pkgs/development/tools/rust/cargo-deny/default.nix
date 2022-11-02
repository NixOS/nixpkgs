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
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = pname;
    rev = version;
    sha256 = "sha256-5JQ4G8wyKf//KU5NRr3fLLDUKsla+965wLj3nWeaEOo=";
  };

  # enable pkg-config feature of zstd
  cargoPatches = [ ./zstd-pkg-config.patch ];

  cargoSha256 = "sha256-dNFwPP/qCyL1JWeE8y8hJR+b30tj0AQFFa42s2XjSzg=";

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
