{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  name = "mmc-utils-${version}";
  version = "2015-11-18";

  src = fetchgit {
    url = "git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc-utils.git";
    rev = "44f94b925894577f9ffcf2c418dd013a5e582648";
    sha256 = "1c1g9jpyhykhmidz7mjzrf63w3xlzqkijrqz1g6j4dz6p9pv1gax";
  };

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
