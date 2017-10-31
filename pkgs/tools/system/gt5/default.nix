{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "gt5-1.4.0";
  
  src = fetchurl {
    url = "mirror://sourceforge/gt5/${name}.tar.gz";
    sha256 = "0gm0gzyp4d9rxqddbaskbz5zvmlhyr4nyb5x9g7x4abyyxqjlnkq";
  };

  patchPhase = ''
    sed 's/-o root -g root//' -i Makefile
  '';

  preConfigure = ''
    makeFlags="$makeFlags PREFIX=$out"
  '';

  meta = {
    description = "A diff-capable 'du' browser";
    homepage = http://gt5.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
