{ stdenv, lib, fetchFromGitHub, fetchpatch, cmake, boost, tbb
, gmp, llvm, clang, sqlite, python3
, ocamlPackages, mpfr, ppl, doxygen, graphviz
}:

let
  inherit (python3.pkgs)
    setuptools
    wheel
    build
    installer
    wrapPython
    pygments
  ;
in

stdenv.mkDerivation rec {
  pname = "ikos";
  version = "3.2";

  src = fetchFromGitHub {
    owner = "NASA-SW-VnV";
    repo = "ikos";
    rev = "v${version}";
    hash = "sha256-zWWfmjYgqhAztGivAJwZ4+yRrAHxgU1CF1Y7vVr95UA=";
  };

  patches = [
  # Fix build with GCC 13
  # https://github.com/NASA-SW-VnV/ikos/pull/262
  (fetchpatch {
    name = "gcc-13.patch";
    url = "https://github.com/NASA-SW-VnV/ikos/commit/73c816641fb9780f0d3b5e448510363a3cf21ce2.patch";
    hash = "sha256-bkeSAtxrL+z+6QNiGOWSg7kN8XiZqMxlJiu5Dquhca0=";
  })
  # Fix an error in ikos-view; Pygments>=2.12 no longer passes outfile to wrap.
  ./formatter-wrap.patch
  ];

  nativeBuildInputs = [ cmake setuptools wheel build installer wrapPython ];
  buildInputs = [ boost tbb gmp clang llvm sqlite python3
                  ocamlPackages.apron mpfr ppl doxygen graphviz ];
  propagatedBuildInputs = [
    pygments
  ];

  cmakeFlags = [
    "-DAPRON_ROOT=${ocamlPackages.apron}"
    "-DINSTALL_PYTHON_VIRTUALENV=off"
    "-DPYTHON_VENV_EXECUTABLE=${python3}/bin/python"
  ];

  postBuild = ''
    make doc
    ${python3}/bin/python -m build --no-isolation --outdir dist/ --wheel analyzer/python
  '';

  postInstall = ''
    ${python3}/bin/python -m installer --prefix "$out" dist/*.whl
  '';

  postFixup = ''
    wrapPythonPrograms
  '';

  meta = with lib; {
    homepage = "https://github.com/NASA-SW-VnV/ikos";
    description = "Static analyzer for C/C++ based on the theory of Abstract Interpretation";
    license = licenses.nasa13;
    maintainers = with maintainers; [ atnnn ];
  };
}
