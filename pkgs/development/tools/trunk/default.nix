{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config
, openssl, libiconv, CoreServices, Security }:

rustPlatform.buildRustPackage rec {
  pname = "trunk";
<<<<<<< HEAD
  version = "0.17.2";
=======
  version = "0.16.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "thedodd";
    repo = "trunk";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-A6h8TmYK5WOcmANk/uM9QO1h767BWASWTwLthtKqrEk=";
=======
    sha256 = "sha256-6o+frbLtuw+DwJiWv4x11qX4GUffhxF19pi/7FLYmHA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = if stdenv.isDarwin
    then [ libiconv CoreServices Security ]
    else [ openssl ];

  # requires network
  checkFlags = [ "--skip=tools::tests::download_and_install_binaries" ];

<<<<<<< HEAD
  cargoHash = "sha256-+jz0J1qFK2fZ4OX089pgNtT2vfiOTf39qQjeXmLoFNs=";
=======
  cargoSha256 = "sha256-j/i2io1JfcNA7eeAXAAKMBtHORZm4J5dOFFNnzvx2cg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://github.com/thedodd/trunk";
    description = "Build, bundle & ship your Rust WASM application to the web";
    maintainers = with maintainers; [ freezeboy ];
    license = with licenses; [ asl20 ];
  };
}
