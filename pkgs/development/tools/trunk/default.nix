{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config
, openssl, libiconv, CoreServices, Security }:

rustPlatform.buildRustPackage rec {
  pname = "trunk";
  version = "0.17.2";

  src = fetchFromGitHub {
    owner = "thedodd";
    repo = "trunk";
    rev = "v${version}";
    sha256 = "sha256-A6h8TmYK5WOcmANk/uM9QO1h767BWASWTwLthtKqrEk=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = if stdenv.isDarwin
    then [ libiconv CoreServices Security ]
    else [ openssl ];

  # requires network
  checkFlags = [ "--skip=tools::tests::download_and_install_binaries" ];

  cargoHash = "sha256-+jz0J1qFK2fZ4OX089pgNtT2vfiOTf39qQjeXmLoFNs=";

  meta = with lib; {
    homepage = "https://github.com/thedodd/trunk";
    description = "Build, bundle & ship your Rust WASM application to the web";
    maintainers = with maintainers; [ freezeboy ];
    license = with licenses; [ asl20 ];
  };
}
