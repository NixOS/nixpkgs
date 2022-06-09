{ lib, stdenv, fetchzip }:

stdenv.mkDerivation {
  pname = "mmc-utils";
  version = "2021-05-11";

  src = fetchzip {
    url = "https://git.kernel.org/pub/scm/utils/mmc/mmc-utils.git/snapshot/mmc-utils-43282e80e174cc73b09b81a4d17cb3a7b4dc5cfc.tar.gz";
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
    homepage = "https://git.kernel.org/pub/scm/utils/mmc/mmc-utils.git/";
    license = licenses.gpl2;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}
