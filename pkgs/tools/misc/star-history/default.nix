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
  version = "1.0.14";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-bdu0LLH6f5rLwzNw1wz0J9zEspYmAOlJYCWOdamWjyw=";
  };

  cargoSha256 = "sha256-Z7zq93Orx7Mb2b9oZxAIPn6qObzYPGOx4N86naUvqtg=";

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
