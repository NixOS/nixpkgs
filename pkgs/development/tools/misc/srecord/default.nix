{ lib, stdenv, fetchurl, boost, libtool, groff, ghostscript, libgcrypt ? null }:

stdenv.mkDerivation rec {
  pname = "srecord";
  version = "1.64";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1qk75q0k5vzmm3932q9hqz2gp8n9rrdfjacsswxc02656f3l3929";
  };

  buildInputs = [ boost libtool groff ghostscript libgcrypt ];

  configureFlags = lib.optional (libgcrypt == null) "--without-gcrypt";

  meta = with lib; {
    description = "Collection of powerful tools for manipulating EPROM load files";
    homepage = "https://srecord.sourceforge.net/";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.bjornfor ];
    platforms = lib.platforms.unix;
  };
}
