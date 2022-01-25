{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "alsa-ucm-conf";
  version = "1.2.6.3";

  src = fetchurl {
    url = "mirror://alsa/lib/${pname}-${version}.tar.bz2";
    sha256 = "sha256-uKA6o4emJKL2XtwgG/d3QhGQtgUpqSCHZGgjr72Wxc0=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/alsa
    cp -r ucm ucm2 $out/share/alsa

    runHook postInstall
  '';

  meta = with lib; {
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
