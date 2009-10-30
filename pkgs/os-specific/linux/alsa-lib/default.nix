{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "alsa-lib-1.0.21a";
  
  src = fetchurl {
    url = "ftp://ftp.alsa-project.org/pub/lib/${name}.tar.bz2";
    sha256 = "0x00sxvf1271vfg829yabaj0xkm4xgvk5vvwcq4qnhn5mnphkkm6";
  };
  
  configureFlags = "--disable-xmlto";
  
  # Fix pcm.h file in order to prevent some compilation bugs
  postPatch = ''
    sed -i -e 's|//int snd_pcm_mixer_element(snd_pcm_t \*pcm, snd_mixer_t \*mixer, snd_mixer_elem_t \*\*elem);|/\*int snd_pcm_mixer_element(snd_pcm_t \*pcm, snd_mixer_t \*mixer, snd_mixer_elem_t \*\*elem);\*/|' include/pcm.h
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
