{ lib, stdenv, fetchFromGitHub, autoreconfHook, flex, libtool }:

stdenv.mkDerivation rec {
  pname = "miller";

  version = "5.10.3";

  src = fetchFromGitHub {
    owner = "johnkerl";
    repo = "miller";
    rev = "v${version}";
    sha256 = "sha256-Mag7bIfZNdp+sM54yKp8HdH3kWjwWRfyPBGthej2jd8=";
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
