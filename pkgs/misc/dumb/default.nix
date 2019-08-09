{ stdenv, fetchFromGitHub, cmake, allegro, SDL2 }:

stdenv.mkDerivation rec {
  name = "dumb-${version}";
  version = "2.0.3";
  enableParallelBuilding = true;
  nativeBuildInputs = [ cmake ];
  buildInputs = [ allegro SDL2 ];

  src = fetchFromGitHub {
    owner = "kode54";
    repo = "dumb";
    rev = version;
    sha256 = "1cnq6rb14d4yllr0yi32p9jmcig8avs3f43bvdjrx4r1mpawspi6";
  };

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE='Release'"
    "-DBUILD_EXAMPLES='OFF'"
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/kode54/dumb";
    description = "Module/tracker based music format parser and player library";
    license = licenses.free;  # Derivative of GPL
    maintainers = with maintainers; [ chiiruno ];
    platforms = platforms.all;
  };
}
