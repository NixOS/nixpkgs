{ stdenv, fetchurl, boost, libtool, groff, ghostscript }:

stdenv.mkDerivation rec {
  name = "srecord-1.62";

  src = fetchurl {
    url = "mirror://sourceforge/srecord/${name}.tar.gz";
    sha256 = "0bfbmhsm9mbwiik3yrhm95q8bgx1k4mh2ai412k8zjyi8f5f3904";
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
