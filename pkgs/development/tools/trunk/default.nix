{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config
, openssl, libiconv, CoreServices, Security }:

rustPlatform.buildRustPackage rec {
  pname = "trunk";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "thedodd";
    repo = "trunk";
    rev = "v${version}";
    sha256 = "sha256-VHUs/trR1M5WacEA0gwKLkGtsws9GFmn1vK0kRxpNII=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = if stdenv.isDarwin
    then [ libiconv CoreServices Security ]
    else [ openssl ];

  # requires network
  checkFlags = [ "--skip=tools::tests::download_and_install_binaries" ];

  cargoSha256 = "sha256-czXe9W+oR1UV7zGZiiHcbydzH6sowa/8upm+5lkPG1U=";

  meta = with lib; {
    homepage = "https://github.com/thedodd/trunk";
    description = "Build, bundle & ship your Rust WASM application to the web";
    maintainers = with maintainers; [ freezeboy ];
    license = with licenses; [ asl20 ];
  };
}
