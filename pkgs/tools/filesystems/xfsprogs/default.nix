{ stdenv, fetchurl, libtool, gettext, libuuid }:

stdenv.mkDerivation rec {
  name = "xfsprogs-3.0.3";

  src = fetchurl {
    url = "ftp://oss.sgi.com/projects/xfs/previous/${name}.tar.gz";
    sha256 = "158ddibsnwcihfvskwc9rknd28p81jk8z463slafp1gf355kmcsq";
  };

  buildInputs = [ libtool gettext libuuid ];

  configureFlags = "MAKE=make MSGFMT=msgfmt MSGMERGE=msgmerge XGETTEXT=xgettext ZIP=gzip AWK=gawk --disable-shared";

  meta = {
    description = "SGI XFS utilities";
  };
}
