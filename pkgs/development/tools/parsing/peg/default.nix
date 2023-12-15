{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "peg";
  version = "0.1.19";

  src = fetchurl {
    url = "${meta.homepage}/${pname}-${version}.tar.gz";
    sha256 = "sha256-ABPdg6Zzl3hEWmS87T10ufUMB1U/hupDMzrl+rXCu7Q=";
  };

  preBuild="makeFlagsArray+=( PREFIX=$out )";

  meta = with lib; {
    homepage = "http://piumarta.com/software/peg/";
    description = "Tools for generating recursive-descent parsers: programs that perform pattern matching on text";
    platforms = platforms.all;
    license = licenses.mit;
  };
}
