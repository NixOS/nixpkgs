{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "alsa-ucm-conf-${version}";
  version = "1.2.2";

  src = fetchurl {
    url = "mirror://alsa/lib/${name}.tar.bz2";
    sha256 = "0364fgzdm2qrsqvgqri25gzscbma7yqlv31wz8b1z9c5phlxkgvy";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/alsa
    cp -r ucm ucm2 $out/share/alsa

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = http://www.alsa-project.org/;
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
