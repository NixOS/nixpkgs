{ stdenv, rustPlatform, fetchFromGitHub, pkgconfig, openssl, cacert, curl }:

rustPlatform.buildRustPackage rec {
  name = "tealdeer-${version}";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "dbrgn";
    repo = "tealdeer";
    rev = "v${version}";
    sha256 = "0mkcja9agkbj2i93hx01r77w66ca805v4wvivcnrqmzid001717v";
  };

  cargoSha256 = "1qrvic7b6g3f3gjzx7x97ipp7ppa79c0aawn0lsav0c9xxzl44jq";

  buildInputs = [ openssl cacert curl ];

  nativeBuildInputs = [ pkgconfig ];
  
  NIX_SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  # disable tests for now since one needs network
  # what is unavailable in sandbox build
  # and i can't disable just this one
  doCheck = false;

  meta = with stdenv.lib; {
    description = "An implementation of tldr in Rust";
    homepage = https://github.com/dbrgn/tealdeer;
    maintainers = with maintainers; [ davidak ];
    license = with licenses; [ asl20 mit ];
    platforms = platforms.all;
  };
}
