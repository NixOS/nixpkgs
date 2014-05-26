{ stdenv, fetchurl, boost, libtool, groff, ghostscript }:

stdenv.mkDerivation rec {
  name = "srecord-1.63";

  src = fetchurl {
    url = "mirror://sourceforge/srecord/${name}.tar.gz";
    sha256 = "06mzj9lrk8lzfzhnfyh8xm4p92j242jik6zm37ihcia20inwgzkq";
  };

  buildInputs = [ boost libtool groff ghostscript ];

  meta = with stdenv.lib; {
    description = "Collection of powerful tools for manipulating EPROM load files";
    homepage = http://srecord.sourceforge.net/;
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.bjornfor ];
    platforms = platforms.linux;
  };
}
