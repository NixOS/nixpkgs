{ stdenv, fetchFromGitHub, autoreconfHook, flex, libtool }:

stdenv.mkDerivation rec {
  name = "miller-${version}";

  version = "5.3.0";

  src = fetchFromGitHub {
    owner = "johnkerl";
    repo = "miller";
    rev = "${version}";
    sha256 = "0abw2n6mi4wbgwihcv3y2xccqx4sj0gdgwvdrg2jkcgraa78sw8v";
  };

  nativeBuildInputs = [ autoreconfHook flex libtool ];

  meta = with stdenv.lib; {
    description = "Miller is like awk, sed, cut, join, and sort for name-indexed data such as CSV, TSV, and tabular JSON.";
    homepage    = "http://johnkerl.org/miller/";
    license     = licenses.bsd2;
    maintainers = with maintainers; [ mstarzyk ];
    platforms   = platforms.all;
  };
}
