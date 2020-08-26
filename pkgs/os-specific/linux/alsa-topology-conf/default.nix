{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "alsa-topology-conf-${version}";
  version = "1.2.3";

  src = fetchurl {
    url = "mirror://alsa/lib/${name}.tar.bz2";
    sha256 = "1zwxc9zhfcmyffjjbibzpdvf4kx7wv9g2zl6xz7y0d6srfr9jgw3";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/alsa
    cp -r topology $out/share/alsa

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.alsa-project.org/";
    description = "ALSA topology configuration files";

    longDescription = ''
      The Advanced Linux Sound Architecture (ALSA) provides audio and
      MIDI functionality to the Linux-based operating system.
    '';

    license = licenses.bsd3;
    maintainers = [ maintainers.roastiek ];
    platforms = platforms.linux;
  };
}
