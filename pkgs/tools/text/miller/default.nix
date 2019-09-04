{ stdenv, fetchFromGitHub, autoreconfHook, flex, libtool }:

stdenv.mkDerivation rec {
  pname = "miller";

  version = "5.5.0";

  src = fetchFromGitHub {
    owner = "johnkerl";
    repo = "miller";
    rev = "v${version}";
    sha256 = "1zkh87vq0gqcx6z6yzf1rq30jmdgdpp0rx5f0vvl0zcn0hc2smpz";
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
