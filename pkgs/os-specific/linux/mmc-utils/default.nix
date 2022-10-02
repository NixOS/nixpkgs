{ lib, stdenv, fetchzip, unstableGitUpdater }:

stdenv.mkDerivation {
  pname = "mmc-utils";
  version = "unstable-2022-09-27";

  src = fetchzip rec {
    url = "https://git.kernel.org/pub/scm/utils/mmc/mmc-utils.git/snapshot/mmc-utils-${passthru.rev}.tar.gz";
    passthru.rev = "dfc3b6ecda84d21418fb4408b39c5c71db4c6458";
    sha256 = "G4sBwRW8NOq7CGTADvXgMbcVInStSueGfGsb4ApVaSk=";
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
