{ stdenv, lib, fetchFromGitHub, cmake, boost
, gmp, llvm, clang, sqlite, python3
, ocamlPackages, mpfr, ppl, doxygen, graphviz
}:

let
  python = python3.withPackages (ps: with ps; [
    pygments
  ]);
in

stdenv.mkDerivation rec {
  name = "ikos";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "NASA-SW-VnV";
    repo = name;
    rev = "v${version}";
    sha256 = "09nf47hpk5w5az4c0hcr5hhwvpz8zg1byyg185542cpzbq1xj8cb";
  };

  buildInputs = [ cmake boost gmp clang llvm sqlite python
                  ocamlPackages.apron mpfr ppl doxygen graphviz ];

  cmakeFlags = "-DAPRON_ROOT=${ocamlPackages.apron}";

  postBuild = "make doc";

  meta = with lib; {
    homepage = https://github.com/NASA-SW-VnV/ikos;
    description = "Static analyzer for C/C++ based on the theory of Abstract Interpretation";
    license = licenses.nasa13;
    maintainers = with maintainers; [ atnnn ];
  };
}
