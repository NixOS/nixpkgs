{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "pgf";
  version = "2.00";

  src = fetchurl {
    url = "mirror://sourceforge/pgf/pgf-${version}.tar.gz";
    sha256 = "0j57niag4jb2k0iyrvjsannxljc3vkx0iag7zd35ilhiy4dh6264";
  };

  dontBuild = true;

  installPhase = "
    mkdir -p $out/share/texmf-nix
    cp -prd * $out/share/texmf-nix
  ";

  meta = with lib; {
    branch = "2";
    platforms = platforms.unix;
    license = licenses.gpl2;
  };
}
