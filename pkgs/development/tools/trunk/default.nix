{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config
, openssl, libiconv, CoreServices, Security }:

rustPlatform.buildRustPackage rec {
  pname = "trunk";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "thedodd";
    repo = "trunk";
    rev = "v${version}";
    sha256 = "sha256-z6/CogY7X3u4BvvP8gRjBeKw0Cci9d6TKZYrKLwoTqs=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = if stdenv.isDarwin
    then [ libiconv CoreServices Security ]
    else [ openssl ];

  # requires network
  checkFlags = [ "--skip=tools::tests::download_and_install_binaries" ];

  cargoHash = "sha256-7j4SNBMNtu4vFkZic4I6Wjlt+oHQ1o8gOxweIq8t7ro=";

  meta = with lib; {
    homepage = "https://github.com/thedodd/trunk";
    description = "Build, bundle & ship your Rust WASM application to the web";
    maintainers = with maintainers; [ freezeboy ];
    license = with licenses; [ asl20 ];
  };
}
