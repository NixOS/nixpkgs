{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config
, openssl, libiconv, CoreServices, Security }:

rustPlatform.buildRustPackage rec {
  pname = "trunk";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "trunk-rs";
    repo = "trunk";
    rev = "v${version}";
    hash = "sha256-riebGbDCqkJTkDmvXCuD0ywjSfGfLgxywkHUPlGzCgI=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = if stdenv.isDarwin
    then [ libiconv CoreServices Security ]
    else [ openssl ];

  # requires network
  checkFlags = [ "--skip=tools::tests::download_and_install_binaries" ];

  cargoHash = "sha256-RMB06jiuD+3uKkNPo5Mfyjl574f5IszTLgQcow0d5uI=";

  meta = with lib; {
    homepage = "https://github.com/trunk-rs/trunk";
    description = "Build, bundle & ship your Rust WASM application to the web";
    maintainers = with maintainers; [ freezeboy ctron ];
    license = with licenses; [ asl20 ];
  };
}
