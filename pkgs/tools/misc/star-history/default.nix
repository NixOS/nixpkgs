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
  version = "1.0.5";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-fmuCmyqw7wubMafkhqL1MltW6jZefgXdnudxdeBRSV4=";
  };

  cargoSha256 = "sha256-+wHOBjBQyMuooDey4Py8xmgW3NNI8t8rCwA8A7D6L84=";

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
