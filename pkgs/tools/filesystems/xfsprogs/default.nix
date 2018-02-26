{ stdenv, fetchpatch, fetchgit, autoconf, automake, gettext, libtool, readline, utillinux }:

let
  gentooPatch = name: sha256: fetchpatch {
    url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/sys-fs/xfsprogs/files/${name}?id=f4055adc94e11d182033a71e32f97b357c034aff";
    inherit sha256;
  };
in

stdenv.mkDerivation rec {
  name = "xfsprogs-${version}";
  version = "4.14.0";

  src = fetchgit {
    url = "git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git";
    rev = "refs/tags/v${version}";
    sha256 = "19mg3avm188xz215hqbbh7251q27qwm7g1xr8ffrjwvzmdq55rxj";
  };

  outputs = [ "bin" "dev" "out" "doc" ];

  nativeBuildInputs = [ autoconf automake libtool gettext ];
  propagatedBuildInputs = [ utillinux ]; # Dev headers include <uuid/uuid.h>
  buildInputs = [ readline ];

  enableParallelBuilding = true;

  # Why is all this garbage needed? Why? Why?
  patches = [
    (gentooPatch "xfsprogs-4.12.0-sharedlibs.patch" "1i081749x91jvlrw84l4a3r081vqcvn6myqhnqbnfcfhd64h12bq")
    (gentooPatch "xfsprogs-4.7.0-libxcmd-link.patch" "1lvy1ajzml39a631a7jqficnzsd40bzkca7hkxv1ybiqyp8sf55s")
    (gentooPatch "xfsprogs-4.9.0-underlinking.patch" "1r7l8jphspy14i43zbfnjrnyrdm4cpgyfchblascxylmans0gci7")
    ./glibc-2.27.patch
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
