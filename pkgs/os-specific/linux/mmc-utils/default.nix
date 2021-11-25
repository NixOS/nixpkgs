{ lib, stdenv, fetchgit }:

stdenv.mkDerivation {
  pname = "mmc-utils";
  version = "2021-05-11";

  src = fetchgit {
    url = "git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc-utils.git";
    rev = "43282e80e174cc73b09b81a4d17cb3a7b4dc5cfc";
    sha256 = "0l06ahmprqshh75pkdpagb8fgnp2bwn8q8hwp1yl3laww2ghm8i5";
  };

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  installPhase = ''
    make install prefix=$out
    mkdir -p $out/share/man/man1
    cp man/mmc.1 $out/share/man/man1/
  '';

  meta = with lib; {
    description = "Configure MMC storage devices from userspace";
    homepage = "http://git.kernel.org/cgit/linux/kernel/git/cjb/mmc-utils.git/";
    license = licenses.gpl2;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}
