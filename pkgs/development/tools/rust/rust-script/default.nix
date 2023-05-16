{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "rust-script";
<<<<<<< HEAD
  version = "0.31.0";
=======
  version = "0.27.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "fornwall";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-W0+UaP0aROfGuvWhPcq6QYJZ6XgUAp4XARTzr3Pch/o=";
  };

  cargoSha256 = "sha256-dNtAee7lyrlamZEtkrrGgs25xW74UixI4NdeD35wzJU=";
=======
    sha256 = "sha256-noyef+G05749WqqqCH6qyVorCR4DRZTl38ftkU66IBQ=";
  };

  cargoSha256 = "sha256-L5uqckG+NbatpBTejZw/Xk+OGZqsJgzHRwCTh1FJHVw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Run Rust files and expressions as scripts without any setup or compilation step";
    homepage = "https://rust-script.org";
    changelog = "https://github.com/fornwall/rust-script/releases/tag/${version}";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
