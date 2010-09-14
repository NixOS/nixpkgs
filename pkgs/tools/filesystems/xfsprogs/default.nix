{ stdenv, fetchurl, libtool, gettext, libuuid }:

stdenv.mkDerivation rec {
  name = "xfsprogs-3.1.3";

  src = fetchurl {
    urls = [ "ftp://oss.sgi.com/projects/xfs/cmd_tars/${name}.tar.gz" "ftp://oss.sgi.com/projects/xfs/previous/${name}.tar.gz" ];
    sha256 = "1mazg6sl4gbm204ndgw585xvcsxg3hg22d989ww6lgmycp635l7s";
  };

  buildInputs = [ libtool gettext libuuid ];

  configureFlags = "MAKE=make MSGFMT=msgfmt MSGMERGE=msgmerge XGETTEXT=xgettext ZIP=gzip AWK=gawk --disable-shared";
  preConfigure = ''
    configureFlags="$configureFlags root_sbindir=$out/sbin root_libdir=$out/lib"
  '';
  disableStatic = false;

  meta = {
    description = "SGI XFS utilities";
  };
}
