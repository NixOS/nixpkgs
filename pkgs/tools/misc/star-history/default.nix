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
  version = "1.0.9";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-el1+Ok8dRaBZMghSvE2xb5RvYq0AQfjeneWrb1so1/s=";
  };

  cargoSha256 = "sha256-VHneYfHr+W1r/B22I3DKIC2XvT8ZjeZIGfTDkneXJss=";

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
