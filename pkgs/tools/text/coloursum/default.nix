{ lib, stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "coloursum";
<<<<<<< HEAD
  version = "0.3.0";
=======
  version = "0.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ticky";
    repo = "coloursum";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-zA2JhSnlFccSY01WMGsgF4AmrF/3BRUCcSMfoEbEPgA=";
  };

  cargoHash = "sha256-dhcTpff4h37MHNbLoYUZiolSclSGcFrMJ3kKLCZAVAw=";
=======
    sha256 = "1piz0l7qdcvjzfykm6rzqc8s1daxp3cj3923v9cmm41bc2v0p5q0";
  };

  cargoSha256 = "08l01ivmln9gwabwa1p0gk454qyxlcpnlxx840vys476f4pw7vvf";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "Colourise your checksum output";
    homepage = "https://github.com/ticky/coloursum";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
  };
}
