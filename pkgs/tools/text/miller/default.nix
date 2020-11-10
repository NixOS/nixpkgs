{ stdenv, fetchFromGitHub, autoreconfHook, flex, libtool }:

stdenv.mkDerivation rec {
  pname = "miller";

  version = "5.9.1";

  src = fetchFromGitHub {
    owner = "johnkerl";
    repo = "miller";
    rev = "v${version}";
    sha256 = "1i9bcpfjnl2yjnfmf0ar1l62zwq01ph0yylz0dby8k2l7cvq5ci6";
  };

  nativeBuildInputs = [ autoreconfHook flex libtool ];

  meta = with stdenv.lib; {
    description = "Like awk, sed, cut, join, and sort for name-indexed data such as CSV, TSV, and tabular JSON";
    homepage    = "http://johnkerl.org/miller/";
    license     = licenses.bsd2;
    maintainers = with maintainers; [ mstarzyk ];
    platforms   = platforms.all;
  };
}
