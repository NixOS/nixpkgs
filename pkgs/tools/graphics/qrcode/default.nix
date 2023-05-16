{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "qrcode";
<<<<<<< HEAD
  version = "unstable-2022-01-10";
=======
  version = "unstable-2016-08-04";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "qsantos";
    repo = "qrcode";
<<<<<<< HEAD
    rev = "f4475866bbf963ad118db936060f606eedc224d5";
    hash = "sha256-IbWYSAc0PvSWcxKaPUXDldGDCK/lPZjptepYtLppPmA=";
=======
    rev = "ad0fdb4aafd0d56b903f110f697abaeb27deee73";
    sha256 = "0v81745nx5gny2g05946k8j553j18a29ikmlyh6c3syq6c15k8cf";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  env.NIX_CFLAGS_COMPILE = "-Wno-error=unused-result";

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  installPhase = ''
    mkdir -p "$out"/{bin,share/doc/qrcode}
    cp qrcode "$out/bin"
    cp DOCUMENTATION LICENCE "$out/share/doc/qrcode"
  '';

  meta = with lib; {
    description = "A small QR-code tool";
<<<<<<< HEAD
    homepage = "https://github.com/qsantos/qrcode";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ raskin ];
    platforms = with platforms; unix;
  };
}
