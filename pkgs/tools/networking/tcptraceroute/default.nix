{ lib
, stdenv
, fetchFromGitHub
, libpcap
, libnet
}:

stdenv.mkDerivation rec {
  pname = "tcptraceroute";
  version = "1.5beta7";

  src = fetchFromGitHub {
    owner = "mct";
    repo = "tcptraceroute";
    rev = "${pname}-${version}";
    hash = "sha256-KU4MLWtOFzzNr+I99fRbhBokhS1JUNL+OgVltkOGav4=";
  };


  # for reasons unknown --disable-static configure flag doesn't disable static
  # linking.. we instead override CFLAGS with -static omitted
  preBuild = ''
    makeFlagsArray=(CFLAGS=" -g -O2 -Wall")
  '';

  buildInputs = [ libpcap libnet ];

  meta = {
    description = "A traceroute implementation using TCP packets";
    homepage = "https://github.com/mct/tcptraceroute";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
    mainProgram = "tcptraceroute";
  };
}
