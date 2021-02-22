{ lib, stdenv, fetchurl, fetchpatch, alsa-ucm-conf, alsa-topology-conf }:

stdenv.mkDerivation rec {
  pname = "alsa-lib";
  version = "1.2.4";

  src = fetchurl {
    url = "mirror://alsa/lib/${pname}-${version}.tar.bz2";
    sha256 = "sha256-91VL4aVs3/RotY/BwpuVtkhkxZADjdMJx6l4xxFpCPc=";
  };

  patches = [
    ./alsa-plugin-conf-multilib.patch
    (fetchpatch {
      # plucked from upstream master, delete in next release
      # without this patch alsa 1.2.4 fails to compile against musl-libc
      # due to an overly conservative ifdef gate in a new feature
      name = "fix-dlo.patch";
      url = "https://github.com/alsa-project/alsa-lib/commit/ad8c8e5503980295dd8e5e54a6285d2d7e32eb1e.patch";
      sha256 = "QQP4C1dSnJP1MNKt2el7Wn3KmtwtYzvyIHWdrHs+Jw4=";
    })
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
