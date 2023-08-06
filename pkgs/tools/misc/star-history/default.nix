{ lib
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "star-history";
  version = "1.0.13";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-WOdiBN/qyszAI4GNFB/RuZd9EV0uj9l5yUnryZ6cqSE=";
  };

  cargoSha256 = "sha256-sET5Gf4vLJAvgdslT+bov9vzCKuTKCEJ0/+JR2GfhmY=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  meta = with lib; {
    description = "Command line program to generate a graph showing number of GitHub stars of a user, org or repo over time";
    homepage = "https://github.com/dtolnay/star-history";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
