{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config
, openssl, libiconv, CoreServices, Security }:

rustPlatform.buildRustPackage rec {
  pname = "trunk";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "thedodd";
    repo = "trunk";
    rev = "v${version}";
    sha256 = "sha256-6o+frbLtuw+DwJiWv4x11qX4GUffhxF19pi/7FLYmHA=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = if stdenv.isDarwin
    then [ libiconv CoreServices Security ]
    else [ openssl ];

  # requires network
  checkFlags = [ "--skip=tools::tests::download_and_install_binaries" ];

  cargoSha256 = "sha256-j/i2io1JfcNA7eeAXAAKMBtHORZm4J5dOFFNnzvx2cg=";

  meta = with lib; {
    homepage = "https://github.com/thedodd/trunk";
    description = "Build, bundle & ship your Rust WASM application to the web";
    maintainers = with maintainers; [ freezeboy ];
    license = with licenses; [ asl20 ];
  };
}
