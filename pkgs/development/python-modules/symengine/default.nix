{ lib
, buildPythonPackage
, fetchFromGitHub
, cython
, cmake
, symengine
, pytest
, sympy
, python
}:

buildPythonPackage rec {
  pname = "symengine";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "symengine";
    repo = "symengine.py";
    rev = "v${version}";
    sha256 = "sha256-kz4M4ghR9Mi8Ig5K+pZC4zHt8XxoP3vU4ATImejqbgg=";
  };

  postConfigure = ''
    substituteInPlace setup.py \
      --replace "\"cmake\"" "\"${cmake}/bin/cmake\"" \
      --replace "'cython>=0.29.24'" "'cython'"

    substituteInPlace cmake/FindCython.cmake \
      --replace "SET(CYTHON_BIN cython" "SET(CYTHON_BIN ${cython}/bin/cython"
  '';

  nativeBuildUnputs = [ cmake ];

  buildInputs = [ cython ];

  checkInputs = [ pytest sympy ];

  setupPyBuildFlags = [
    "--symengine-dir=${symengine}/"
    "--define=\"CYTHON_BIN=${cython}/bin/cython\""
  ];

  checkPhase = ''
    mkdir empty
    cd empty
    ${python.interpreter} ../bin/test_python.py
  '';

  meta = with lib; {
    description = "Python library providing wrappers to SymEngine";
    homepage = "https://github.com/symengine/symengine.py";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
