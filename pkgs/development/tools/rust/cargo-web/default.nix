{ lib, stdenv, fetchFromGitHub, openssl, perl, pkg-config, rustPlatform
, CoreServices, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-web";
  version = "0.6.26";

  src = fetchFromGitHub {
    owner = "koute";
    repo = pname;
    rev = version;
    sha256 = "1dl5brj5fnmxmwl130v36lvy4j64igdpdvjwmxw3jgg2c6r6b7cd";
  };

  cargoSha256 = "0q7yxvvngfvn4s889qzp1qnsw2c6qy2ryv9vz9cxhmqidx4dg4va";

  nativeBuildInputs = [ openssl perl pkg-config ];
  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices Security ];

  meta = with lib; {
    description = "A Cargo subcommand for the client-side Web";
    homepage = "https://github.com/koute/cargo-web";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ kevincox ];
  };
}
