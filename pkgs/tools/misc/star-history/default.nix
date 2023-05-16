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
<<<<<<< HEAD
  version = "1.0.14";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-bdu0LLH6f5rLwzNw1wz0J9zEspYmAOlJYCWOdamWjyw=";
  };

  cargoSha256 = "sha256-Z7zq93Orx7Mb2b9oZxAIPn6qObzYPGOx4N86naUvqtg=";
=======
  version = "1.0.11";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-Cbhg0KLDi2GOEP9KwwExcoX5wE2kMM41biXLrlWLKvY=";
  };

  cargoSha256 = "sha256-RbTwJx8ueMAOl9cx6YxGEsjARxcZhJXHhyWWYPTdpI4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
