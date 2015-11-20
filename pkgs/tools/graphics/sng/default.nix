{ stdenv, fetchurl, libpng, netpbm }:

stdenv.mkDerivation rec {
  name = "sng-${version}";
  version = "1.0.6";

  src = fetchurl {
    url = "mirror://sourceforge/sng/sng-${version}.tar.gz";
    sha256 = "04ym62qh8blsqigm3kr1shj9pn62y373wdaavk74rzwjzlhwhmq6";
  };

  buildInputs = [ libpng ];

  configureFlags = [
    "--with-rgbtxt=${netpbm}/share/netpbm/misc/rgb.txt"
  ];

  meta = with stdenv.lib; {
    description = "Minilanguage designed to represent the entire contents of a PNG file in an editable form";
    homepage = http://sng.sourceforge.net/;
    license = licenses.zlib;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}
