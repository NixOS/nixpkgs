{ lib, stdenv
, fetchFromGitHub
, rustPlatform
, pkg-config
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

  cargoPatches = [
    ./update-deps.patch
  ];

  cargoSha256 = "130gqvzpyr055xkqcy1r0y7l5k2dcv7n9zgr4ja7dm7iayzbwwi1";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    # LibreSSL works around segfault issues caused by OpenSSL being unable to
    # gracefully exit while doing work.
    # See: https://github.com/rustwasm/wasm-pack/issues/650
    libressl
  ] ++ lib.optionals stdenv.isDarwin [ curl Security ];

  # Most tests rely on external resources and build artifacts.
  # Disabling check here to work with build sandboxing.
  doCheck = false;

  meta = with lib; {
    description = "A utility that builds rust-generated WebAssembly package";
    homepage = "https://github.com/rustwasm/wasm-pack";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.dhkl ];
  };
}
