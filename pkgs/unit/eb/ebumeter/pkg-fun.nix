{ lib, stdenv, fetchurl
, libX11, libXft, libclthreads, libclxclient, libjack2, libpng, libsndfile, zita-resampler
}:

stdenv.mkDerivation rec {
  pname = "ebumeter";
  version = "0.4.2";

  src = fetchurl {
    url = "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/${pname}-${version}.tar.bz2";
    sha256 = "1wm9j1phmpicrp7jdsvdbc3mghdd92l61yl9qbps0brq2ljjyd5s";
  };

  buildInputs = [
    libX11 libXft libclthreads libclxclient libjack2 libpng libsndfile zita-resampler
  ];

  preConfigure = ''
    cd source
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Level metering according to the EBU R-128 recommendation";
    homepage = "http://kokkinizita.linuxaudio.org/linuxaudio/index.html";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
