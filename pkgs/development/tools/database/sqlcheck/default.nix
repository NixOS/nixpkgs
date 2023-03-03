{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "sqlcheck";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "jarulraj";
    repo = "sqlcheck";
    rev = "v${version}";
    sha256 = "sha256-rGqCtEO2K+OT44nYU93mF1bJ07id+ixPkRSC8DcO6rY=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  doCheck = true;

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Automatically identify anti-patterns in SQL queries";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = [ maintainers.marsam ];
  };
}
