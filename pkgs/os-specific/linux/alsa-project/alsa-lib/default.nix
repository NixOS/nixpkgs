{ lib
, stdenv
, fetchurl
, alsa-topology-conf
, alsa-ucm-conf
}:

stdenv.mkDerivation rec {
  pname = "alsa-lib";
  version = "1.2.5.1";

  src = fetchurl {
    url = "mirror://alsa/lib/${pname}-${version}.tar.bz2";
    sha256 = "sha256-YoQh2VDOyvI03j+JnVIMCmkjMTyWStdR/6wIHfMxQ44=";
  };

  patches = [
    ./alsa-plugin-conf-multilib.patch
  ];

  enableParallelBuilding = true;

  # Fix pcm.h file in order to prevent some compilation bugs
  postPatch = ''
    sed -i -e 's|//int snd_pcm_mixer_element(snd_pcm_t \*pcm, snd_mixer_t \*mixer, snd_mixer_elem_t \*\*elem);|/\*int snd_pcm_mixer_element(snd_pcm_t \*pcm, snd_mixer_t \*mixer, snd_mixer_elem_t \*\*elem);\*/|' include/pcm.h
  '';

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
  };
}
