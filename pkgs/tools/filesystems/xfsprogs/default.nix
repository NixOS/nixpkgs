{ stdenv, buildPackages, fetchpatch, fetchgit, autoconf, automake, gettext, libtool, pkgconfig
, icu, libuuid, readline
}:

let
  gentooPatch = name: sha256: fetchpatch {
    url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/sys-fs/xfsprogs/files/${name}?id=2517dd766cf84d251631f4324f7ec4bce912abb9";
    inherit sha256;
  };
in

stdenv.mkDerivation rec {
  name = "xfsprogs-${version}";
  version = "4.19.0";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git";
    rev = "v${version}";
    sha256 = "18728hzfxr1bg4bdzqlxjs893ac1zwlfr7nmc2q4a1sxs0sphd1d";
  };

  outputs = [ "bin" "dev" "out" "doc" ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [
    autoconf automake libtool gettext pkgconfig
    libuuid # codegen tool uses libuuid
  ];
  buildInputs = [ readline icu ];
  propagatedBuildInputs = [ libuuid ]; # Dev headers include <uuid/uuid.h>

  enableParallelBuilding = true;

  # Why is all this garbage needed? Why? Why?
  patches = [
    (gentooPatch "xfsprogs-4.15.0-sharedlibs.patch" "0bv2naxpiw7vcsg8p1v2i47wgfda91z1xy1kfwydbp4wmb4nbyyv")
    (gentooPatch "xfsprogs-4.15.0-docdir.patch" "1srgdidvq2ka0rmfdwpqp92fapgh53w1h7rajm4nnby5vp2v8dfr")
    (gentooPatch "xfsprogs-4.9.0-underlinking.patch" "1r7l8jphspy14i43zbfnjrnyrdm4cpgyfchblascxylmans0gci7")
  ];

  preConfigure = ''
    sed -i Makefile -e '/cp include.install-sh/d'
    make configure
  '';

  configureFlags = [
    "--disable-lib64"
    "--enable-readline"
  ];

  installFlags = [ "install-dev" ];

  # FIXME: forbidden rpath
  postInstall = ''
    find . -type d -name .libs | xargs rm -rf
  '';

  meta = with stdenv.lib; {
    homepage = http://xfs.org/;
    description = "SGI XFS utilities";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dezgeg ];
  };
}
