{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "bgpq4";
  version = "1.8";

  src = fetchFromGitHub {
    owner = "bgp";
    repo = pname;
    rev = version;
    sha256 = "sha256-y1Btpp1xzjAezLaIJBF2+ghMgC/p8mHS/hStGIaKb1o=";
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
