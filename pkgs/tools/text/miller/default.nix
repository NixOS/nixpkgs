{ lib, stdenv, fetchFromGitHub, autoreconfHook, flex, libtool }:

stdenv.mkDerivation rec {
  pname = "miller";

  version = "5.10.2";

  src = fetchFromGitHub {
    owner = "johnkerl";
    repo = "miller";
    rev = "v${version}";
    sha256 = "sha256-NI57U3FpUfQ6ouBEYrzzG+9kpL58BD4HoAuRAFJMO9k=";
  };

  nativeBuildInputs = [ autoreconfHook flex libtool ];

  meta = with lib; {
    description = "Like awk, sed, cut, join, and sort for name-indexed data such as CSV, TSV, and tabular JSON";
    homepage    = "http://johnkerl.org/miller/";
    license     = licenses.bsd2;
    maintainers = with maintainers; [ mstarzyk ];
    platforms   = platforms.all;
  };
}
