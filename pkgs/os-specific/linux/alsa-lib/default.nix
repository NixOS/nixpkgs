{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "alsa-lib-1.2.1.1";

  src = fetchurl {
    url = "mirror://alsa/lib/${name}.tar.bz2";
    sha256 = "1v1c0a3xxqp3fxz77qy45pvjw2vb15lhb5kx8nnachxd18yccnn9";
  };

  patches = [
    ./alsa-plugin-conf-multilib.patch
  ];

  # Fix pcm.h file in order to prevent some compilation bugs
  # 2: see http://stackoverflow.com/questions/3103400/how-to-overcome-u-int8-t-vs-uint8-t-issue-efficiently
  postPatch = ''
    sed -i -e 's|//int snd_pcm_mixer_element(snd_pcm_t \*pcm, snd_mixer_t \*mixer, snd_mixer_elem_t \*\*elem);|/\*int snd_pcm_mixer_element(snd_pcm_t \*pcm, snd_mixer_t \*mixer, snd_mixer_elem_t \*\*elem);\*/|' include/pcm.h


    sed -i -e '1i#include <stdint.h>' include/pcm.h
    sed -i -e 's/u_int\([0-9]*\)_t/uint\1_t/g' include/pcm.h
  '';

  outputs = [ "out" "dev" ];

  meta = with stdenv.lib; {
    homepage = http://www.alsa-project.org/;
    description = "ALSA, the Advanced Linux Sound Architecture libraries";

    longDescription = ''
      The Advanced Linux Sound Architecture (ALSA) provides audio and
      MIDI functionality to the Linux-based operating system.
    '';

    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
