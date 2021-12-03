{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "alsa-ucm-conf-${version}";
  version = "1.2.5.1";

  src = fetchurl {
    url = "mirror://alsa/lib/${name}.tar.bz2";
    sha256 = "sha256-WEGkRBZty/R523UTA9vDVW9oUIWsfgDwyed1VnYZXZc=";
  };

  patches = [
    ./0001-HDA-improve-init.conf-Capture-volume-switches.patch
    ./0002-HDA-improve-support-for-HDAudio-Gigabyte-ALC1220Dual.patch
    ./0003-HDA-patch-to-work-with-v1.2.5.1.patch
  ];

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
