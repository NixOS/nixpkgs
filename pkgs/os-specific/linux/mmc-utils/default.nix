{ lib, stdenv, fetchzip, unstableGitUpdater }:

stdenv.mkDerivation {
  pname = "mmc-utils";
  version = "unstable-2023-06-12";

  src = fetchzip rec {
    url = "https://git.kernel.org/pub/scm/utils/mmc/mmc-utils.git/snapshot/mmc-utils-${passthru.rev}.tar.gz";
    passthru.rev = "6d593efc3cd00e4debd0ffc5806246390dc66242";
    sha256 = "QOrU47cTPnvJHM40Bjq51VSSinmRnXCimk1h5mt4vNw=";
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
