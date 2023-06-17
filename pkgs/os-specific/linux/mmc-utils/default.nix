{ lib, stdenv, fetchzip, unstableGitUpdater }:

stdenv.mkDerivation {
  pname = "mmc-utils";
  version = "unstable-2023-04-17";

  src = fetchzip rec {
    url = "https://git.kernel.org/pub/scm/utils/mmc/mmc-utils.git/snapshot/mmc-utils-${passthru.rev}.tar.gz";
    passthru.rev = "145c74ab6f2e13a9a8ccdbbf1758afedb8a3965c";
    sha256 = "cYLIO83uZHDe1COKtSN0SyFOoC3qrqMP0RNsOO9cQ70=";
  };

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" "prefix=$(out)" ];

  postInstall = ''
    mkdir -p $out/share/man/man1
    cp man/mmc.1 $out/share/man/man1/
  '';

  enableParallelBuilding = true;

  passthru.updateScript = unstableGitUpdater {
    url = "https://git.kernel.org/pub/scm/utils/mmc/mmc-utils.git";
  };

  meta = with lib; {
    description = "Configure MMC storage devices from userspace";
    homepage = "https://git.kernel.org/pub/scm/utils/mmc/mmc-utils.git/";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}
