<<<<<<< HEAD
{ lib, stdenv, fetchFromGitHub }:
=======
{ lib, stdenv, fetchFromGitHub, substituteAll }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

stdenv.mkDerivation rec {
  pname = "srt-to-vtt-cl";
  version = "unstable-2019-01-03";

  src = fetchFromGitHub {
    owner = "nwoltman";
    repo = pname;
    rev = "ce3d0776906eb847c129d99a85077b5082f74724";
    sha256 = "0qxysj08gjr6npyvg148llmwmjl2n9cyqjllfnf3gxb841dy370n";
  };

  patches = [
<<<<<<< HEAD
    ./fix-validation.patch
    ./simplify-macOS-builds.patch
=======
    (substituteAll {
      src = ./fix-validation.patch;
    })
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  installPhase = ''
    mkdir -p $out/bin
<<<<<<< HEAD
    cp bin/srt-vtt $out/bin
=======
    cp bin/$(uname -s)/$(uname -m)/srt-vtt $out/bin
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  meta = with lib; {
    description = "Convert SRT files to VTT";
    license = licenses.mit;
    maintainers = with maintainers; [ ericdallo ];
    homepage = "https://github.com/nwoltman/srt-to-vtt-cl";
<<<<<<< HEAD
    platforms = platforms.unix;
=======
    platforms = platforms.linux;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
