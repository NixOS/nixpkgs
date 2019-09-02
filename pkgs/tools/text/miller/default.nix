{ stdenv, fetchurl, autoreconfHook, flex, libtool }:

stdenv.mkDerivation rec {
  pname = "miller";

  version = "5.5.0";

  src = fetchurl {
    url = "https://github.com/johnkerl/miller/releases/download/v${version}/mlr-${version}.tar.gz";
    sha256 = "06pkmqfv325igpcyjcq6sqr1r6gab7a7qdfw6kw6a6kwksgk5f8d";
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
