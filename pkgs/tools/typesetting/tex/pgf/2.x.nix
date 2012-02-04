{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "pgf-2.00";
  
  src = fetchurl {
    url = mirror://sourceforge/pgf/pgf-2.00.tar.gz;
    sha256 = "0j57niag4jb2k0iyrvjsannxljc3vkx0iag7zd35ilhiy4dh6264";
  };

  buildPhase = "true";
  
  installPhase = "
    ensureDir $out/share/texmf-nix
    cp -prd * $out/share/texmf-nix
  ";
}
