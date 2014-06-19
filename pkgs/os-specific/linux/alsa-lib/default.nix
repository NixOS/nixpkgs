{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "alsa-lib-1.0.28";

  src = fetchurl {
    urls = [
     "ftp://ftp.alsa-project.org/pub/lib/${name}.tar.bz2"
     "http://alsa.cybermirror.org/lib/${name}.tar.bz2"
    ];
    sha256 = "0vaafg5q1q1mqcsgin5v7xlmngl3cnbmg5a9xxw0xcz1vn2ln1rw";
  };

  patches = [
    /* allow specifying alternatives alsa plugin locations using
       export ALSA_PLUGIN_DIRS=$(nix-build -A alsaPlugins)/lib/alsa-lib
       This patch should be improved:
       See http://thread.gmane.org/gmane.linux.distributions.nixos/3435
    */
    ./alsa-plugin-dirs.patch
  ];

  # Fix pcm.h file in order to prevent some compilation bugs
  # 2: see http://stackoverflow.com/questions/3103400/how-to-overcome-u-int8-t-vs-uint8-t-issue-efficiently
  postPatch = ''
    sed -i -e 's|//int snd_pcm_mixer_element(snd_pcm_t \*pcm, snd_mixer_t \*mixer, snd_mixer_elem_t \*\*elem);|/\*int snd_pcm_mixer_element(snd_pcm_t \*pcm, snd_mixer_t \*mixer, snd_mixer_elem_t \*\*elem);\*/|' include/pcm.h


    sed -i -e '1i#include <stdint.h>' include/pcm.h
    sed -i -e 's/u_int\([0-9]*\)_t/uint\1_t/g' include/pcm.h
  '';

  crossAttrs = {
    patchPhase = ''
      sed -i s/extern/static/g include/iatomic.h
    '';
  };

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
