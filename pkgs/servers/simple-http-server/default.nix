{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "simple-http-server";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "TheWaWaR";
    repo = pname;
    rev = "v${version}";
    sha256 = "01a129i1ph3m8k6zkdcqnnkqbhlqpk7qvvdsz2i2kas54csbgsww";
  };

  cargoSha256 = "050avk6wff8v1dlsfvxwvldmmgfakdxmhglv2bhvc2f3q8cf1d5d";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = if stdenv.isDarwin then [ Security ] else [ openssl ];

  # Currently no tests are implemented, so we avoid building the package twice
  doCheck = false;

  meta = with lib; {
    description = "Simple HTTP server in Rust";
    homepage = "https://github.com/TheWaWaR/simple-http-server";
    license = licenses.mit;
    maintainers = with maintainers; [ mephistophiles ];
  };
}
