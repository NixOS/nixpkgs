{ stdenv
, fetchFromGitHub
, rustPlatform
, pkgconfig
, libressl
, curl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "wasm-pack";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "rustwasm";
    repo = "wasm-pack";
    rev = "v${version}";
    sha256 = "1rqyfg6ajxxyfx87ar25nf5ck9hd0p12qgv98dicniqag8l4rvsr";
  };

  cargoSha256 = "0fw04hgxxqsbp1pylp32yd087r9bb8bpa05v90qdshkgp6znfl9s";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [
    # LibreSSL works around segfault issues caused by OpenSSL being unable to
    # gracefully exit while doing work.
    # See: https://github.com/rustwasm/wasm-pack/issues/650
    libressl
  ] ++ stdenv.lib.optionals stdenv.isDarwin [ curl Security ];

  # Most tests rely on external resources and build artifacts.
  # Disabling check here to work with build sandboxing.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A utility that builds rust-generated WebAssembly package";
    homepage = https://github.com/rustwasm/wasm-pack;
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.dhkl ];
    platforms = platforms.all;
  };
}
