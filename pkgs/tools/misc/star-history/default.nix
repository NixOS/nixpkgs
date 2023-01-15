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
  version = "1.0.10";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-zDWfeyZTQ4yaBK3vuX6+Rb6/+DFOESMDTQ7Bg/XN06I=";
  };

  cargoSha256 = "sha256-epIqjmQStSHdpEH7YVnsHVz3tEIz3cdJY9O+lzg7b2Q=";

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
