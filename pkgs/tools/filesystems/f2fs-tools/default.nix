{ stdenv, fetchgit, autoconf, automake, libtool, pkgconfig, libuuid }:

stdenv.mkDerivation rec {
  name = "f2fs-tools-${version}";
  version = "1.4.1";

  src = fetchgit {
    url = git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs-tools.git;
    rev = "refs/tags/v${version}";
    sha256 = "16i74r2656q6x4gg5kgjy2fxipr5czbm10r66s34pi2lfczbwhjr";
  };

  buildInputs = [ autoconf automake libtool pkgconfig libuuid ];

  preConfigure = ''
    sed -i '/AC_SUBST/d' configure.ac
    autoreconf --install
  '';

  meta = with stdenv.lib; {
    homepage = "http://git.kernel.org/cgit/linux/kernel/git/jaegeuk/f2fs-tools.git/";
    description = "Userland tools for the f2fs filesystem";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ emery jagajaga ];
  };
}
