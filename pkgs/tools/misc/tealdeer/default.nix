{ stdenv, rustPlatform, fetchFromGitHub, pkgconfig, openssl, cacert, curl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "tealdeer";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "dbrgn";
    repo = "tealdeer";
    rev = "v${version}";
    sha256 = "0l16qqkrya22nnm4j3dxyq4gb85i3c07p10s00bpqcvki6n6v6r8";
  };

  cargoSha256 = "0jvgcf493rmkrh85j0fkf8ffanva80syyxclzkvkrzvvwwj78b5l";

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
