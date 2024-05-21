{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "ascii";
  version = "3.20";

  src = fetchurl {
    url = "http://www.catb.org/~esr/ascii/${pname}-${version}.tar.gz";
    sha256 = "sha256-nm5X6mDUGagDoCTOY2YlTvtxYma4Tu3VjNmA2rzBFnQ=";
  };

  prePatch = ''
    sed -i -e "s|^PREFIX = .*|PREFIX = $out|" Makefile
  '';

  preInstall = ''
    mkdir -vp "$out/bin" "$out/share/man/man1"
  '';

  meta = with lib; {
    description = "Interactive ASCII name and synonym chart";
    mainProgram = "ascii";
    homepage = "http://www.catb.org/~esr/ascii/";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
  };
}
