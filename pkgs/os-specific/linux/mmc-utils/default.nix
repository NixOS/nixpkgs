{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  name = "mmc-utils-${version}";
  version = "2018-03-27";

  src = fetchgit {
    url = "git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc-utils.git";
    rev = "b4fe0c8c0e57a74c01755fa9362703b60d7ee49d";
    sha256 = "01llwan5j40mv5p867f31lm87qh0hcyhy892say60y5pxc0mzpyn";
  };

  makeFlags = "CC=${stdenv.cc.targetPrefix}cc";

  installPhase = ''
    make install prefix=$out
    mkdir -p $out/share/man/man1
    cp man/mmc.1 $out/share/man/man1/
  '';

  meta = with stdenv.lib; {
    description = "Configure MMC storage devices from userspace";
    homepage = http://git.kernel.org/cgit/linux/kernel/git/cjb/mmc-utils.git/;
    license = licenses.gpl2;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}
