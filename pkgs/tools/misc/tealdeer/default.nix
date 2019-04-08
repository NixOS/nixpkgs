{ stdenv, rustPlatform, fetchFromGitHub, pkgconfig, openssl, cacert, curl }:

rustPlatform.buildRustPackage rec {
  name = "tealdeer-${version}";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "dbrgn";
    repo = "tealdeer";
    rev = "v${version}";
    sha256 = "055pjxgiy31j69spq66w80ig469yi075dk8ad38z6rlvjmf74k71";
  };

  cargoSha256 = "1jxwz2b6p82byvfjx77ba265j6sjr7bjqi2yik8x2i7lrz8v8z1g";

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
