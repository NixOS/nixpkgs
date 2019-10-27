{ stdenv, rustPlatform, fetchFromGitHub, pkgconfig, openssl, cacert, curl }:

rustPlatform.buildRustPackage rec {
  pname = "tealdeer";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "dbrgn";
    repo = "tealdeer";
    rev = "v${version}";
    sha256 = "055pjxgiy31j69spq66w80ig469yi075dk8ad38z6rlvjmf74k71";
  };

  cargoSha256 = "0yrz2pq4zdv6hzc8qc1zskpkq556mzpwvzl7qzbfzx8b6g31ak19";

  buildInputs = [ openssl cacert curl ];

  nativeBuildInputs = [ pkgconfig ];
  
  NIX_SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  # disable tests for now since one needs network
  # what is unavailable in sandbox build
  # and i can't disable just this one
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A very fast implementation of tldr in Rust";
    homepage = "https://github.com/dbrgn/tealdeer";
    maintainers = with maintainers; [ davidak ];
    license = with licenses; [ asl20 mit ];
    platforms = platforms.all;
  };
}
