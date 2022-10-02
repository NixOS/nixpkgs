{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "fakeroute";
  version = "0.3";

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
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
