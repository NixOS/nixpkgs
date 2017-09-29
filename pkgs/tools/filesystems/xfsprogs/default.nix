{ stdenv, fetchpatch, fetchgit, autoconf, automake, gettext, libtool, readline, utillinux }:

let
  gentooPatch = name: sha256: fetchpatch {
    url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/sys-fs/xfsprogs/files/${name}?id=8293574ab30c85e2965fb2b7dd890b44841b8404";
    inherit sha256;
  };
in

stdenv.mkDerivation rec {
  name = "xfsprogs-${version}";
  version = "4.11.0";

  src = fetchgit {
    url = "git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git";
    rev = "refs/tags/v${version}";
    sha256 = "0icliinacg6c3ziaqzyyxfz9jykn80njj9fdv3milhsf81yhnrpn";
  };

  outputs = [ "bin" "dev" "out" "doc" ];

  nativeBuildInputs = [ autoconf automake libtool gettext ];
  propagatedBuildInputs = [ utillinux ]; # Dev headers include <uuid/uuid.h>
  buildInputs = [ readline ];

  enableParallelBuilding = true;

  # Why is all this garbage needed? Why? Why?
  patches = [
    (gentooPatch "xfsprogs-4.7.0-sharedlibs.patch" "1s83ihaccmjrw4zm0nbdwqk3jx4wc1rijpsqrg7ir71ln7qknwzz")
    (gentooPatch "xfsprogs-4.7.0-libxcmd-link.patch" "1lvy1ajzml39a631a7jqficnzsd40bzkca7hkxv1ybiqyp8sf55s")
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
