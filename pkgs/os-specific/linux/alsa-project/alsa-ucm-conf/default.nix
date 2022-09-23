{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "alsa-ucm-conf";
  version = "1.2.7.1";

  src = fetchurl {
    url = "mirror://alsa/lib/${pname}-${version}.tar.bz2";
    hash = "sha256-rFsqEnV4Pv8H4cs0w2xsWYd0JnmjQAN1B8BKncHSLKw=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/alsa
    cp -r ucm ucm2 $out/share/alsa

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.alsa-project.org/";
    description = "ALSA Use Case Manager configuration";

    longDescription = ''
      The Advanced Linux Sound Architecture (ALSA) provides audio and
      MIDI functionality to the Linux-based operating system.
    '';

    license = licenses.bsd3;
    maintainers = [ maintainers.roastiek ];
    platforms = platforms.linux;
  };
}
