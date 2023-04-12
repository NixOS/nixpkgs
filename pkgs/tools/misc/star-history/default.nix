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
  version = "1.0.11";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-Cbhg0KLDi2GOEP9KwwExcoX5wE2kMM41biXLrlWLKvY=";
  };

  cargoSha256 = "sha256-RbTwJx8ueMAOl9cx6YxGEsjARxcZhJXHhyWWYPTdpI4=";

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
