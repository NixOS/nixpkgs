{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "bgpq4";
  version = "1.13";

  src = fetchFromGitHub {
    owner = "bgp";
    repo = pname;
    rev = version;
    sha256 = "sha256-Kw1Y9g2ItclDYYoZC2FTdBTec7zoM/N3Vk4zM8EVBR0=";
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
    mainProgram = "bgpq4";
  };
}
