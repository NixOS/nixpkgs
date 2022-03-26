{ stdenv, lib, fetchFromGitHub, cmake, boost, tbb
, gmp, llvm, clang, sqlite, python3
, ocamlPackages, mpfr, ppl, doxygen, graphviz
}:

let
  python = python3.withPackages (ps: with ps; [
    pygments
  ]);
in

stdenv.mkDerivation rec {
  pname = "ikos";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "NASA-SW-VnV";
    repo = "ikos";
    rev = "v${version}";
    sha256 = "0k3kp1af0qx3l1x6a4sl4fm8qlwchjvwkvs2ck0fhfnc62q2im5f";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost tbb gmp clang llvm sqlite python
                  ocamlPackages.apron mpfr ppl doxygen graphviz ];

  cmakeFlags = [ "-DAPRON_ROOT=${ocamlPackages.apron}" ];

  postBuild = "make doc";

  meta = with lib; {
    homepage = "https://github.com/NASA-SW-VnV/ikos";
    description = "Static analyzer for C/C++ based on the theory of Abstract Interpretation";
    license = licenses.nasa13;
    maintainers = with maintainers; [ atnnn ];
  };
}
