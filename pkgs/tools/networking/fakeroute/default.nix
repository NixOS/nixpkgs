<<<<<<< HEAD
{ lib, stdenv, fetchurl, nixosTests }:
=======
{ lib, stdenv, fetchFromGitHub }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

stdenv.mkDerivation rec {
  pname = "fakeroute";
  version = "0.3";

<<<<<<< HEAD
  src = fetchurl {
    url = "https://maxwell.ydns.eu/git/rnhmjoj/fakeroute/releases/download/v${version}/fakeroute-${version}.tar.gz";
    hash = "sha256-DoXGJm8vOlAD6ZuvVAt6bkgfahc8WgyYIXCrgqzfiWg=";
  };

  passthru.tests.fakeroute = nixosTests.fakeroute;

  meta = with lib; {
    description = ''
      Make your machine appears to be anywhere on the internet in a traceroute
    '';
    homepage = "https://maxwell.ydns.eu/git/rnhmjoj/fakeroute";
=======
  src = fetchFromGitHub {
    owner = "museoa";
    repo = "fakeroute";
    rev = "f8cb9c0ae3abb4c0662d9e1fcac67eefeeac3963";
    sha256 = "12dhahwlpjzv79wpdpryjihamfbh4d8cfzfw4wi1jkl0dv2d41jg";
  };

  sourceRoot = "source/fakeroute-0.3";

  meta = with lib; {
    description = ''
      Makes your machine appear to be anywhere on the internet
      to any host running a (UDP) unix traceroute
    '';
    homepage = "https://github.com/museoa/fakeroute"; # Formerly https://moxie.org/software/fakeroute/
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
