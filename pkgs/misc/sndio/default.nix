{ stdenv, fetchurl, alsaLib }:

stdenv.mkDerivation rec {
  pname = "sndio";
  version = "1.7.0";
  enableParallelBuilding = true;
  buildInputs = stdenv.lib.optionals stdenv.isLinux [ alsaLib ];

  src = fetchurl {
    url = "http://www.sndio.org/sndio-${version}.tar.gz";
    sha256 = "0ljmac0lnjn61admgbcwjfcr5fwccrsblx9rj9bys8wlhz8f796x";
  };

  postFixup = stdenv.lib.optionalString stdenv.isDarwin ''
    install_name_tool -id $out/lib/libsndio.7.0.dylib $out/lib/libsndio.7.0.dylib
    for file in $out/bin/*; do
      install_name_tool -change libsndio.7.0.dylib $out/lib/libsndio.dylib $file
    done
  '';

  meta = with stdenv.lib; {
    homepage = "http://www.sndio.org";
    description = "Small audio and MIDI framework part of the OpenBSD project";
    license = licenses.isc;
    maintainers = with maintainers; [ chiiruno ];
    platforms = platforms.all;
  };
}
