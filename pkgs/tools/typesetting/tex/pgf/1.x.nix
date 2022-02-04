{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "pgf";
  version = "1.18";

  src = fetchurl {
    url = "mirror://sourceforge/pgf/pgf-${version}.tar.gz";
    sha256 = "0s6b8rx9yfxcjjg18vx1mphnwbd28fl5lnq0dasjz40pp3ypwdjv";
  };

  dontBuild = true;

  installPhase = "
    mkdir -p $out/share/texmf-nix
    cp -prd * $out/share/texmf-nix
  ";

  meta = with lib; {
    branch = "1";
    platforms = platforms.unix;
    license = licenses.gpl2;
  };
}
