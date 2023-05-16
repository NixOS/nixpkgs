{ lib, stdenv, fetchzip, unstableGitUpdater }:

stdenv.mkDerivation {
  pname = "mmc-utils";
<<<<<<< HEAD
  version = "unstable-2023-08-07";

  src = fetchzip rec {
    url = "https://git.kernel.org/pub/scm/utils/mmc/mmc-utils.git/snapshot/mmc-utils-${passthru.rev}.tar.gz";
    passthru.rev = "613495ecaca97a19fa7f8f3ea23306472b36453c";
    sha256 = "zOjm/YDxqU6bu6GMyQTuzuZbrCfaU4FBodRWLb8GTdE=";
=======
  version = "unstable-2023-04-17";

  src = fetchzip rec {
    url = "https://git.kernel.org/pub/scm/utils/mmc/mmc-utils.git/snapshot/mmc-utils-${passthru.rev}.tar.gz";
    passthru.rev = "145c74ab6f2e13a9a8ccdbbf1758afedb8a3965c";
    sha256 = "cYLIO83uZHDe1COKtSN0SyFOoC3qrqMP0RNsOO9cQ70=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" "prefix=$(out)" ];

<<<<<<< HEAD
  # causes redefinition of _FORTIFY_SOURCE
  hardeningDisable = [ "fortify3" ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
