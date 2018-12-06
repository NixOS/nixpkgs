{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "nbench-byte-${version}";
  version = "2.2.3";

  src = fetchurl {
    url = "http://www.math.utah.edu/~mayer/linux/${name}.tar.gz";
    sha256 = "1b01j7nmm3wd92ngvsmn2sbw43sl9fpx4xxmkrink68fz1rx0gbj";
  };

  buildInputs = [ stdenv.cc.libc.static ];
  prePatch = ''
    substituteInPlace nbench1.h --replace '"NNET.DAT"' "\"$out/NNET.DAT\""
  '';
  preBuild = ''
    makeFlagsArray=(CC=$CC)
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp nbench $out/bin
    cp NNET.DAT $out
  '';

  meta = with stdenv.lib; {
    homepage = https://www.math.utah.edu/~mayer/linux/bmark.html;
    description = "A synthetic computing benchmark program";
    platforms = platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ bennofs ];
  };
}
