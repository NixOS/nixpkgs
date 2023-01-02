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
  version = "1.0.8";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-ya2wUcO/2V/JHJ005p63j9Qu6oQehGYDhCYE7a5MBDA=";
  };

  cargoSha256 = "sha256-zmgOQNaodZrl/rsYOpv6nTu/IDaQYQ94jeUg3LOvvuA=";

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
