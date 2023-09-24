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
  version = "1.0.15";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-9/r01j/47rbgmXQy9qVOeY1E3LDMe9A/1SOB2l9zpJU=";
  };

  cargoSha256 = "sha256-kUpGBtgircX8/fACed4WO7rHTCah+3BFuQQV/A5pivg=";

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
