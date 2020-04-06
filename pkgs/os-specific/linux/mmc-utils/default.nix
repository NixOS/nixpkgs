{ stdenv, fetchgit }:

stdenv.mkDerivation {
  pname = "mmc-utils";
  version = "2018-12-14";

  src = fetchgit {
    url = "git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc-utils.git";
    rev = "aef913e31b659462fe6b9320d241676cba97f67b";
    sha256 = "1mak9rqjp6yvqk2h5hfil5a9gfx138h62n3cryckfbhr6fmaylm7";
  };

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

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
