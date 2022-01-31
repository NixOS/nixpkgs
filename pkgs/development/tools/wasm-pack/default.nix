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
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "rustwasm";
    repo = "wasm-pack";
    rev = "v${version}";
    sha256 = "sha256-nhO/SLeJTq2viDqsJCRNLbgjyDKRli3RWExUNzKT9ug=";
  };

  cargoSha256 = "sha256-6qrCHpg92IRPsf/dK6xcLGX8BLmqox3vgLRqsV4ubsY=";

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
