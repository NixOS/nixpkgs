{ stdenv, fetchurl, gettext, libuuid, readline }:

stdenv.mkDerivation rec {
  name = "xfsprogs-3.2.2";

  src = fetchurl {
    urls = map (dir: "ftp://oss.sgi.com/projects/xfs/${dir}/${name}.tar.gz")
      [ "cmd_tars" "previous" ];
    sha256 = "1aszsqz7gkqdagads18ybslbfkyxq893rykmsz9lm7f33pi5qlhs";
  };

  prePatch = ''
    sed -i s,/bin/bash,`type -P bash`,g install-sh
    sed -i s,ldconfig,`type -P ldconfig`,g configure m4/libtool.m4

    # Fixes from gentoo 3.2.1 ebuild
    sed -i "/^PKG_DOC_DIR/s:@pkg_name@:${name}:" include/builddefs.in
    sed -i '1iLLDFLAGS = -static' {estimate,fsr}/Makefile
    sed -i "/LLDFLAGS/s:-static::" $(find -name Makefile)
    sed -i '/LIB_SUBDIRS/s:libdisk::' Makefile
  '';

  patches = [
    # This patch fixes shared libs installation, still not fixed in 3.2.2
    ./xfsprogs-3.2.2-sharedlibs.patch
  ];

  buildInputs = [ gettext libuuid readline ];

  outputs = [ "out" "lib" ];

  preConfigure = ''
    NIX_LDFLAGS="$(echo $NIX_LDFLAGS | sed "s,$out,$lib,g")"
  '';

  configureFlags = [
    "MAKE=make"
    "MSGFMT=msgfmt"
    "MSGMERGE=msgmerge"
    "XGETTEXT=xgettext"
    "--disable-lib64"
    "--enable-readline"
    "--includedir=$(lib)/include"
    "--libdir=$(lib)/lib"
  ];

  installFlags = [ "install-dev" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://xfs.org/;
    description = "SGI XFS utilities";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington ];
  };
}
