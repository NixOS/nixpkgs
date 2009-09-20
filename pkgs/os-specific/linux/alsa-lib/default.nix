{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "alsa-lib-1.0.19";
  src = fetchurl {
    url = ftp://ftp.alsa-project.org/pub/lib/alsa-lib-1.0.19.tar.bz2;
    sha256 = "11i898dc6qbachn046gl6dg6g7bl2k8crddl97f3z5i57bcjdvij";
  };  
  configureFlags = "--disable-xmlto";
  # Fix pcm.h file in order to prevent some compilation bugs
  patchPhase = ''
    sed -i -e 's|//int snd_pcm_mixer_element(snd_pcm_t \*pcm, snd_mixer_t \*mixer, snd_mixer_elem_t \*\*elem);|/\*int snd_pcm_mixer_element(snd_pcm_t \*pcm, snd_mixer_t \*mixer, snd_mixer_elem_t \*\*elem);\*/|' include/pcm.h
    unset patchPhase; patchPhase
  '';
  meta = {
    description = "ALSA, the Advanced Linux Sound Architecture libraries";

    longDescription = ''
      The Advanced Linux Sound Architecture (ALSA) provides audio and
      MIDI functionality to the Linux-based operating system.
    '';

    homepage = http://www.alsa-project.org/;
  };

  patches = [
    /* allow specifying alternatives alsa plugin locations using
       export ALSA_PLUGIN_DIRS=$(nix-build -A alsaPlugins)/lib/alsa-lib */
    ./alsa-plugin-dirs.patch
  ];
}
