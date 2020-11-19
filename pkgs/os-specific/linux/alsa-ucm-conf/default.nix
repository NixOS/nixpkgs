{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "alsa-ucm-conf-${version}";
  version = "1.2.4";

  src = fetchurl {
    url = "mirror://alsa/lib/${name}.tar.bz2";
    sha256 = "0h6kzi1cfdqyxp4pwpqh5wb89c8s9wrgix315bvamffwfxf56frc";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/alsa
    cp -r ucm ucm2 $out/share/alsa

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.alsa-project.org/";
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
