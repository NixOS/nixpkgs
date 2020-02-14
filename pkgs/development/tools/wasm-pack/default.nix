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

  # Delete this on next update; see #79975 for details
  legacyCargoFetcher = true;

  cargoSha256 = "095gk6lcck5864wjhrkhgnkxn9pzcg82xk5p94br7lmf15y9gc7j";

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
