{ stdenv, fetchFromGitHub, autoreconfHook, flex, libtool }:

stdenv.mkDerivation rec {
  name = "miller-${version}";

  version = "5.2.2";

  src = fetchFromGitHub {
    owner = "johnkerl";
    repo = "miller";
    rev = "v${version}";
    sha256 = "1i5lyknsf4vif601l070xh5sz8jy2h359jrb0kc0s0pl8lypxs4i";
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
