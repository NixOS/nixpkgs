{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "pgf-1.18";

  src = fetchurl {
    url = mirror://sourceforge/pgf/pgf-1.18.tar.gz;
    sha256 = "0s6b8rx9yfxcjjg18vx1mphnwbd28fl5lnq0dasjz40pp3ypwdjv";
  };

  dontBuild = true;

  installPhase = "
    mkdir -p $out/share/texmf-nix
    cp -prd * $out/share/texmf-nix
  ";

  meta = {
    branch = "1";
  };
}
