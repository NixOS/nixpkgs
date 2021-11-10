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
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = pname;
    rev = version;
    sha256 = "sha256-ZpTwqwxh1/Yz5MBlv1KvD/sBTaFb5m7cQXLkUAGZegc=";
  };

  cargoSha256 = "sha256-JwljoLTEolKCaob7IPYan5N9YIZvnlj1uRZ1mNACGbQ=";

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
