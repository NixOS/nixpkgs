{ stdenv, fetchzip
, boost, clasp, cmake, gringo, re2c
}:

stdenv.mkDerivation rec {
  version = "1.9.4";
  name = "aspcud-${version}";

  src = fetchzip {
    url = "https://github.com/potassco/aspcud/archive/v${version}.tar.gz";
    sha256 = "0vrf7h7g99vw1mybqfrpxamsnf89p18czlzgjmxl1zkiwc7vjpzw";
  };

  buildInputs = [ boost clasp cmake gringo re2c ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DASPCUD_GRINGO_PATH=${gringo}/bin/gringo"
    "-DASPCUD_CLASP_PATH=${clasp}/bin/clasp"
  ];

  meta = with stdenv.lib; {
    description = "Solver for package problems in CUDF format using ASP";
    homepage = "https://potassco.org/aspcud/";
    platforms = platforms.all;
    maintainers = [ maintainers.hakuch ];
    license = licenses.gpl3Plus;
  };
}
