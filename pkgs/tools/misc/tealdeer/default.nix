{ stdenv, rustPlatform, fetchFromGitHub, pkgconfig, openssl, cacert, curl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "tealdeer";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "dbrgn";
    repo = "tealdeer";
    rev = "v${version}";
    sha256 = "1v9wq4k7k4lmdz6xy6kabchjpbx9lds20yh6va87shypdh9iva29";
  };

  cargoSha256 = "0y1y74fgxcv8a3cmyf30p6gg12r79ln7inir8scj88wbmwgkbxsp";

  buildInputs = [ openssl cacert curl ]
    ++ (stdenv.lib.optional stdenv.isDarwin Security);

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
