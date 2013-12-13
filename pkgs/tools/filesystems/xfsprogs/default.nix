{ stdenv, fetchurl, libtool, gettext, libuuid }:

stdenv.mkDerivation rec {
  name = "xfsprogs-3.1.11";

  src = fetchurl {
    urls = [ "ftp://oss.sgi.com/projects/xfs/cmd_tars/${name}.tar.gz" "ftp://oss.sgi.com/projects/xfs/previous/${name}.tar.gz" ];
    sha256 = "1gnnyhy3khl08a24c5y0pyakz6nnwkiw1fc6rb0r1j5mfw0rix5d";
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
