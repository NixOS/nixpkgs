{ stdenv, fetchurl, libpng }:

stdenv.mkDerivation rec {
  name = "pngcrush-1.7.76";

  src = fetchurl {
    url = "mirror://sourceforge/pmt/${name}-nolib.tar.xz";
    sha256 = "0jbv3ijc0nfhy6pkhv4dwbk2v488rwixd8rv1c7lfs59wblb44hv";
  };

  configurePhase = ''
    sed -i s,/usr,$out, Makefile
  '';

  buildInputs = [ libpng ];

  meta = {
    homepage = http://pmt.sourceforge.net/pngcrush;
    description = "A PNG optimizer";
    license = "free";
    platforms = with stdenv.lib.platforms; linux;
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
  };
}
