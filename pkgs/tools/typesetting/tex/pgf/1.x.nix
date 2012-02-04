{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "pgf-1.10";
  
  src = fetchurl {
    url = mirror://sourceforge/pgf/pgf-1.10.tar.gz;
    sha256 = "1y605wmjxryphh0y5zgzvdq6xjxb2bjb95j36d4wg1a7n93ksswl";
  };

  buildPhase = "true";
  installPhase = "
    ensureDir $out/share/texmf-nix
    cp -prd * $out/share/texmf-nix
  ";
}
