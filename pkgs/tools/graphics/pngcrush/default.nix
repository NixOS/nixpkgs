{ stdenv, fetchurl, libpng }:

stdenv.mkDerivation rec {
  name = "pngcrush-1.7.85";

  src = fetchurl {
    url = "mirror://sourceforge/pmt/${name}-nolib.tar.xz";
    sha256 = "1hvcync32x2ign694scafkj7xc73gzyy8n2l5z026yxckilyyv19";
  };

  configurePhase = ''
    sed -i s,/usr,$out, Makefile
  '';

  buildInputs = [ libpng ];

  meta = {
    homepage = http://pmt.sourceforge.net/pngcrush;
    description = "A PNG optimizer";
    license = stdenv.lib.licenses.free;
    platforms = with stdenv.lib.platforms; linux;
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
  };
}
