{ stdenv, fetchurl, alsaLib }:

stdenv.mkDerivation rec {
  pname = "sndio";
  version = "1.6.0";
  enableParallelBuilding = true;
  buildInputs = stdenv.lib.optionals stdenv.isLinux [ alsaLib ];

  src = fetchurl {
    url = "http://www.sndio.org/sndio-${version}.tar.gz";
    sha256 = "1havdx3q4mipgddmd2bnygr1yh6y64567m1yqwjapkhsq550dq4r";
  };

  postFixup = stdenv.lib.optionalString stdenv.isDarwin ''
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
