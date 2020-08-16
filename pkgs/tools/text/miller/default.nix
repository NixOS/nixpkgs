{ stdenv, fetchFromGitHub, autoreconfHook, flex, libtool }:

stdenv.mkDerivation rec {
  pname = "miller";

  version = "5.8.0";

  src = fetchFromGitHub {
    owner = "johnkerl";
    repo = "miller";
    rev = "v${version}";
    sha256 = "06y1l730xps196jbnxahmd5alc9ba5m8hakm9sc8hx1q5b9ylfih";
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
