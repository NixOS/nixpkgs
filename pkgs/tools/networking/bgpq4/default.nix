{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "bgpq4";
  version = "1.12";

  src = fetchFromGitHub {
    owner = "bgp";
    repo = pname;
    rev = version;
    sha256 = "sha256-Irv91M5g21id0QfsnpDA7n5IhP8Qe9QHMh/KizD74qw=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  meta = with lib; {
    description = "BGP filtering automation tool";
    homepage = "https://github.com/bgp/bgpq4";
    license = licenses.bsd2;
    maintainers = with maintainers; [ vincentbernat ];
    platforms = with platforms; unix;
  };
}
