{ stdenv, fetchgit, autoconf, automake, libtool, pkgconfig, libuuid }:

stdenv.mkDerivation rec {
  name = "f2fs-tools-${version}";
  version = "1.3.0";

  src = fetchgit {
    url = git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs-tools.git;
    rev = "refs/tags/v${version}";
    sha256 = "1r97k91qaf42jz623jqy0wm97yjq1ym034q4fdhfirq27s46sn6i";
  };

  buildInputs = [ autoconf automake libtool pkgconfig libuuid ];

  preConfigure = ''
    sed -i '/AC_SUBST/d' configure.ac
    autoreconf --install
  '';

  meta = {
    homepage = "http://git.kernel.org/cgit/linux/kernel/git/jaegeuk/f2fs-tools.git/";
    description = "Userland tools for the f2fs filesystem";
    license = stdenv.lib.licenses.gpl2;
  };
}
