<<<<<<< HEAD
{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "pwnat";
  # Latest release has an annoying segmentation fault bug, see:
  # https://github.com/samyk/pwnat/pull/25 . Merging only #25 is impossible due
  # to major code refactoring.
  version = "2023-03-31";
=======
{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name  = "${pname}-${date}";
  pname = "pwnat";
  date  = "2014-09-08";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner  = "samyk";
    repo   = pname;
<<<<<<< HEAD
    rev    = "8ec62cdae53a2d573c9f9c906133ca45bbd3360a";
    sha256 = "sha256-QodNw3ab8/TurKamg6AgMfQ08aalp4j6q663B+sWmRM=";
  };

  # See https://github.com/samyk/pwnat/issues/28
  preBuild = ''
    mkdir obj
  '';

  installPhase = ''
    runHook preInstall

    install -D pwnat $out/bin/pwnat

    runHook postInstall
=======
    rev    = "1d07c2eb53171733831c0cd01e4e96a3204ec446";
    sha256 = "056xhlnf1axa6k90i018xwijkwc9zc7fms35hrkzwgs40g9ybrx5";
  };

  installPhase = ''
    mkdir -p $out/bin $out/share/pwnat
    cp pwnat $out/bin
    cp README* COPYING* $out/share/pwnat
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  meta = with lib; {
    homepage    = "http://samy.pl/pwnat/";
    description = "ICMP NAT to NAT client-server communication";
    license     = lib.licenses.gpl3Plus;
    maintainers = with maintainers; [viric];
    platforms   = with platforms; linux;
  };
}
