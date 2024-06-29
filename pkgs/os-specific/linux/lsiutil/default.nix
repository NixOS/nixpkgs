{ lib
, stdenv
, fetchurl
, kmod
, coreutils
}:

stdenv.mkDerivation rec {
  pname = "lsiutil";
  version = "1.72";

  src = fetchurl {
    url = "https://github.com/exactassembly/meta-xa-stm/raw/f96cf6e13f3c9c980f5651510dd96279b9b2af4f/recipes-support/lsiutil/files/lsiutil-${version}.tar.gz";
    sha256 = "sha256-aTi+EogY1aDWYq3anjRkjz1mzINVfUPQbOPHthxrvS4=";
  };

  postPatch = ''
    substituteInPlace lsiutil.c \
      --replace /sbin/modprobe "${kmod}/bin/modprobe" \
      --replace /bin/mknod "${coreutils}/bin/mknod"
  '';

  buildPhase = ''
    runHook preBuild

    gcc -Wall -O lsiutil.c -o lsiutil

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    install -Dm755 lsiutil "$out/bin/lsiutil"

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/exactassembly/meta-xa-stm/tree/master/recipes-support/lsiutil/files";
    description = "Configuration utility for MPT adapters (FC, SCSI, and SAS/SATA)";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ Luflosi ];
  };
}
