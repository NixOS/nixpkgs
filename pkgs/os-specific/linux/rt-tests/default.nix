{
  stdenv,
  lib,
  makeWrapper,
  fetchurl,
  numactl,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "rt-tests";
  version = "2.7";

  src = fetchurl {
    url = "https://git.kernel.org/pub/scm/utils/rt-tests/rt-tests.git/snapshot/${pname}-${version}.tar.gz";
    sha256 = "sha256-1kfLmB1RPO8Hd7o8tROSyVBWchchc+AGPuOUlM2hR8g=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    numactl
    python3
  ];

  makeFlags = [
    "prefix=$(out)"
    "DESTDIR="
    "PYLIB=$(out)/${python3.sitePackages}"
  ];

  postInstall = ''
    wrapProgram "$out/bin/determine_maximum_mpps.sh" --prefix PATH : $out/bin
  '';

  meta = with lib; {
    homepage = "https://git.kernel.org/pub/scm/utils/rt-tests/rt-tests.git";
    description = "Suite of real-time tests - cyclictest, hwlatdetect, pip_stress, pi_stress, pmqtest, ptsematest, rt-migrate-test, sendme, signaltest, sigwaittest, svsematest";
    platforms = platforms.linux;
    maintainers = with maintainers; [ poelzi ];
    license = licenses.gpl2Only;
  };
}
