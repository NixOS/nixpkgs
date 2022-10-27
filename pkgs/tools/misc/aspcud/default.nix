{ lib
, stdenv
, fetchFromGitHub
, boost
, catch2
, clasp
, cmake
, gringo
, re2c
}:

stdenv.mkDerivation rec {
  version = "1.9.6";
  pname = "aspcud";

  src = fetchFromGitHub {
    owner = "potassco";
    repo = "aspcud";
    rev = "v${version}";
    hash = "sha256-PdRfpmH7zF5dn+feoijtzdSUjaYhjHwyAUfuYoWCL9E=";
  };

  postPatch = ''
    cp ${catch2}/include/catch2/catch.hpp libcudf/tests/catch.hpp
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost clasp gringo re2c ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DASPCUD_GRINGO_PATH=${gringo}/bin/gringo"
    "-DASPCUD_CLASP_PATH=${clasp}/bin/clasp"
  ];

  doCheck = true;

  meta = with lib; {
    description = "Solver for package problems in CUDF format using ASP";
    homepage = "https://potassco.org/aspcud/";
    platforms = platforms.all;
    maintainers = [ maintainers.hakuch ];
    license = licenses.gpl3Plus;
  };
}
