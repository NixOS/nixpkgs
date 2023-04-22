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
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "rustwasm";
    repo = "wasm-pack";
    rev = "v${version}";
    sha256 = "sha256-3iwXoYnmrZsbwFUR41uI/4jnCF0OjeRO7UqVDaGJJbQ=";
  };

  cargoHash = "sha256-Z0hmJ4/o9DNYz3JVXGgaDfw1JNcvvTCLngmhIDiVR6E=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    # LibreSSL works around segfault issues caused by OpenSSL being unable to
    # gracefully exit while doing work.
    # See: https://github.com/rustwasm/wasm-pack/issues/650
    libressl
  ] ++ lib.optionals stdenv.isDarwin [ curl Security ];

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;

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
