{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, curl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-deny";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = pname;
    rev = version;
    sha256 = "sha256-YXIEM8COtjc3yD8gxoeoJwkGyJwMCCn40591iO6ERxc=";
  };

  cargoSha256 = "sha256-4PcYnpoRvl01n4Y4usrlLejWwcB5BJnFGqqfbqLD1gI=";

  doCheck = false;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ curl Security ];

  cargoBuildFlags = [ "--no-default-features" ];

  cargoTestFlags = cargoBuildFlags;

  meta = with lib; {
    description = "Cargo plugin to generate list of all licenses for a crate";
    homepage = "https://github.com/EmbarkStudios/cargo-deny";
    changelog = "https://github.com/EmbarkStudios/cargo-deny/blob/${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
  };
}
