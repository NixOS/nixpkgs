{ lib
, stdenv
, fetchFromGitHub
, boost
, clasp
, cmake
, gringo
, re2c
}:

stdenv.mkDerivation rec {
  version = "1.9.5";
  pname = "aspcud";

  src = fetchFromGitHub {
    owner = "potassco";
    repo = "aspcud";
    rev = "v${version}";
    hash = "sha256-d04GPMoz6PMGq6iiul0zT1C9Mljdl9uJJ2C8MIwcmaw=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost clasp gringo re2c ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DASPCUD_GRINGO_PATH=${gringo}/bin/gringo"
    "-DASPCUD_CLASP_PATH=${clasp}/bin/clasp"
  ];

  meta = with lib; {
    description = "Solver for package problems in CUDF format using ASP";
    homepage = "https://potassco.org/aspcud/";
    platforms = platforms.all;
    maintainers = [ maintainers.hakuch ];
    license = licenses.gpl3Plus;
  };
}
