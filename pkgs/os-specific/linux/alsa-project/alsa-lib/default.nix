{ lib
, stdenv
, fetchurl
, alsa-topology-conf
, alsa-ucm-conf
}:

stdenv.mkDerivation rec {
  pname = "alsa-lib";
  version = "1.2.6.1";

  src = fetchurl {
    url = "mirror://alsa/lib/${pname}-${version}.tar.bz2";
    hash = "sha256-rVgpk9Us21+xWaC+q2CmrFfqsMwb34XcTbbWGX8CMz8=";
  };

  patches = [
    ./alsa-plugin-conf-multilib.patch
  ];

  enableParallelBuilding = true;

  postInstall = ''
    ln -s ${alsa-ucm-conf}/share/alsa/{ucm,ucm2} $out/share/alsa
    ln -s ${alsa-topology-conf}/share/alsa/topology $out/share/alsa
  '';

  outputs = [ "out" "dev" ];

  meta = with lib; {
    homepage = "http://www.alsa-project.org/";
    description = "ALSA, the Advanced Linux Sound Architecture libraries";

    longDescription = ''
      The Advanced Linux Sound Architecture (ALSA) provides audio and
      MIDI functionality to the Linux-based operating system.
    '';

    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ l-as ];
  };
}
