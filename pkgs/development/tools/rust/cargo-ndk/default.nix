{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
<<<<<<< HEAD
, CoreGraphics
, Foundation
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-ndk";
<<<<<<< HEAD
  version = "3.3.0";
=======
  version = "3.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "bbqsrc";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-jMhDKMFJVz/PdMnSrA+moknXPfwFhPj/fggHDAUCsNY=";
  };

  cargoHash = "sha256-IUMS0oCucYeBSfjxIYl0hhJw2GIpSgh+Vm1iUQ+Jceo=";

  buildInputs = lib.optionals stdenv.isDarwin [
    CoreGraphics
    Foundation
  ];
=======
    sha256 = "sha256-fPN5me8+KrnFR0NkWVxWm8OXZbObUWsYKChldme0qyc=";
  };

  cargoHash = "sha256-UEQ+6N7D1/+vhdzYthcTP1YuVEmo5llrpndKuwmrjKc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Cargo extension for building Android NDK projects";
    homepage = "https://github.com/bbqsrc/cargo-ndk";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ mglolenstine ];
<<<<<<< HEAD
=======
    platforms = platforms.linux;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}

