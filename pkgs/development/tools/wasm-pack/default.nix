{ lib, stdenv
, fetchFromGitHub
, rustPlatform
, pkg-config
, libressl
, curl
, Security
, zstd
}:

rustPlatform.buildRustPackage rec {
  pname = "wasm-pack";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "rustwasm";
    repo = "wasm-pack";
    rev = "v${version}";
    sha256 = "sha256-oIMS0kln+HCW9kFfLU+Vi0/4EYKYzzlA1BQHZNQkJMI=";
  };

  cargoHash = "sha256-l6zn714DMQ+frU9Mppz4LuGY6Zf9qmxZ9MuwIvYvQMU=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    # LibreSSL works around segfault issues caused by OpenSSL being unable to
    # gracefully exit while doing work.
    # See: https://github.com/rustwasm/wasm-pack/issues/650
    libressl
    zstd
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
