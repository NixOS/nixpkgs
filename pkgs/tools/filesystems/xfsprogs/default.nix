{ stdenv, fetchurl, gettext, libuuid, readline }:

stdenv.mkDerivation rec {
  name = "xfsprogs-4.5.0";

  src = fetchurl {
    urls = map (dir: "ftp://oss.sgi.com/projects/xfs/${dir}/${name}.tar.gz")
      [ "cmd_tars" "previous" ];
    sha256 = "1y49rwvbbvqdq2a1x7p5i05bcfyv6xhmrfwafl6vvvw494qyp6z4";
  };

  prePatch = ''
    sed -i "s,/bin/bash,$(type -P bash),g" install-sh
    sed -i "s,ldconfig,$(type -P ldconfig),g" configure m4/libtool.m4

    # Fixes from gentoo 3.2.1 ebuild
    sed -i "/^PKG_DOC_DIR/s:@pkg_name@:${name}:" include/builddefs.in
    sed -i "/LLDFLAGS.*libtool-libs/d" $(find -name Makefile)
    sed -i '/LIB_SUBDIRS/s:libdisk::' Makefile
  '';

  patches = [
    # This patch fixes shared libs installation, still not fixed in 4.2.0
    ./4.3.0-sharedlibs.patch
  ];

  propagatedBuildInputs = [ libuuid ];
  buildInputs = [ gettext readline ];

  outputs = [ "bin" "dev" "out" ]; # TODO: review xfs

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
