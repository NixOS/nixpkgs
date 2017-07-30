{ stdenv, fetchurl, boost, libtool, groff, ghostscript, libgcrypt ? null }:

stdenv.mkDerivation rec {
  name = "srecord-1.64";

  src = fetchurl {
    url = "mirror://sourceforge/srecord/${name}.tar.gz";
    sha256 = "1qk75q0k5vzmm3932q9hqz2gp8n9rrdfjacsswxc02656f3l3929";
  };

  buildInputs = [ boost libtool groff ghostscript libgcrypt ];

  configureFlags = stdenv.lib.optionalString
    (libgcrypt == null) "--without-gcrypt";

  meta = with stdenv.lib; {
    description = "Collection of powerful tools for manipulating EPROM load files";
    homepage = http://srecord.sourceforge.net/;
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.bjornfor ];
    platforms = stdenv.lib.platforms.unix;
  };
}
