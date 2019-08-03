{ stdenv, fetchFromGitHub, autoreconfHook, flex, libtool }:

stdenv.mkDerivation rec {
  name = "miller-${version}";

  version = "5.4.0";

  src = fetchFromGitHub {
    owner = "johnkerl";
    repo = "miller";
    rev = "${version}";
    sha256 = "0158by642frh9x6rrgqxwmk4766wb36kp0rrjg5swdbs9w3is3xg";
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
