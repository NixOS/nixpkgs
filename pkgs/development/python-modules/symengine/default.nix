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
  version = "0.7.0.post3";

  src = fetchFromGitHub {
    owner = "symengine";
    repo = "symengine.py";
    rev = "v${version}";
    sha256 = "1hpwnnv6f7f2wj33zaaj3i2r0d0qj0jwm3fd4ayicj0rvqya50rx";
  };

  postConfigure = ''
    substituteInPlace setup.py \
      --replace "\"cmake\"" "\"${cmake}/bin/cmake\""

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
