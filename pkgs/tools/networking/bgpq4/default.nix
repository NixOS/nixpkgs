{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "bgpq4";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "bgp";
    repo = pname;
    rev = version;
    sha256 = "1n6d6xq7vafx1la0fckqv0yjr245ka9dgbcqaz9m6dcdk0fdlkks";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  meta = with stdenv.lib; {
    description = "BGP filtering automation tool";
    homepage = "https://github.com/bgp/bgpq4";
    license = licenses.bsd2;
    maintainers = with maintainers; [ vincentbernat ];
    platforms = with platforms; unix;
  };
}
