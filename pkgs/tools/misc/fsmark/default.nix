{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "fsmark";
  version = "3.3";

  src = fetchurl {
    url = "mirror://sourceforge/fsmark/${version}/fs_mark-${version}.tar.gz";
    sha256 = "15f8clcz49qsfijdmcz165ysp8v4ybsm57d3dxhhlnq1bp1i9w33";
  };

  patchPhase = ''
    runHook prePatch

    sed -i Makefile -e 's/-static //'

    runHook postPatch
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp fs_mark $out/bin/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Synchronous write workload file system benchmark";
    homepage = "https://sourceforge.net/projects/fsmark/";
    license = licenses.gpl2;
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.linux;
  };
}
