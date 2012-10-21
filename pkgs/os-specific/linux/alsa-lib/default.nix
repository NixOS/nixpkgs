{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "alsa-lib-1.0.26";
  
  src = fetchurl {
    urls = [
     "ftp://ftp.alsa-project.org/pub/lib/${name}.tar.bz2"
     "http://alsa.cybermirror.org/lib/${name}.tar.bz2"
    ];
    sha256 = "0zbfkwqn7ixa71lsna9llq6i2gic540h8r8r0rjdphrwc1hq37wc";
  };
  
  configureFlags = "--disable-xmlto";
  
  # Fix pcm.h file in order to prevent some compilation bugs
  postPatch = ''
    sed -i -e 's|//int snd_pcm_mixer_element(snd_pcm_t \*pcm, snd_mixer_t \*mixer, snd_mixer_elem_t \*\*elem);|/\*int snd_pcm_mixer_element(snd_pcm_t \*pcm, snd_mixer_t \*mixer, snd_mixer_elem_t \*\*elem);\*/|' include/pcm.h
  '';

  crossAttrs = {
    patchPhase = ''
      sed -i s/extern/static/g include/iatomic.h
    '';
  };
  
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
       export ALSA_PLUGIN_DIRS=$(nix-build -A alsaPlugins)/lib/alsa-lib
       This patch should be improved:
       See http://thread.gmane.org/gmane.linux.distributions.nixos/3435
    */
    ./alsa-plugin-dirs.patch

    /* patch provided by larsc on irc.
       it may be a compiler problem on mips; without this, alsa does not build
       on mips, because lacks some symbols atomic_add/atomic_sub  */
    ./mips-atomic.patch
  ];
}
