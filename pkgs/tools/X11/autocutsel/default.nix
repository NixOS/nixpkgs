{stdenv, fetchurl, libX11, libXaw}:

stdenv.mkDerivation rec {
  version = "0.10.0";
  name = "autocutsel-${version}";
 
  src = fetchurl {
    url = "https://github.com/sigmike/autocutsel/releases/download/${version}/${name}.tar.gz";
    sha256 = "0gsys2dzh4az51ndcsabhlbbrjn2nm75lnjr45kg6r8sm8q66dx2";
  };
 
  buildInputs = [ libX11 libXaw ];
  installPhase = ''
    mkdir -p $out/bin
    cp autocutsel $out/bin/
  '';

  meta = {
    inherit version;
    homepage = https://www.nongnu.org/autocutsel/;
    description = "Tracks changes in the server's cutbuffer and CLIPBOARD selection";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = with stdenv.lib.platforms; all;
    updateWalker = true;
  };
}
