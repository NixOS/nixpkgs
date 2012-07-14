{ stdenv, fetchurl, libtool, gettext, libuuid }:

stdenv.mkDerivation rec {
  name = "xfsprogs-3.1.8";

  src = fetchurl {
    urls = [ "ftp://oss.sgi.com/projects/xfs/cmd_tars/${name}.tar.gz" "ftp://oss.sgi.com/projects/xfs/previous/${name}.tar.gz" ];
    sha256 = "1aryr6w76hyc1dznfzk0sc5rlr914rr0zh15vyclj1s86wp9wh3l";
  };

  patchPhase = ''
    sed -i s,/bin/bash,`type -P bash`, install-sh
  '';

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
