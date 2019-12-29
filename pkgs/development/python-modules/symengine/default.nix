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
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "symengine";
    repo = "symengine.py";
    rev = "v${version}";
    sha256 = "0nk553za7f9dp5fb0lsqj30y5cpmzlwzrhwrn0bcd99nd0r0hwvd";
  };

  postConfigure = ''
    substituteInPlace setup.py \
      --replace "\"cmake\"" "\"${cmake}/bin/cmake\""

    substituteInPlace cmake/FindCython.cmake \
      --replace "SET(CYTHON_BIN cython" "SET(CYTHON_BIN ${cython}/bin/cython"
  '';

  nativeBuildInputs = [
    cython
  ];

  checkInputs = [
    pytest
    sympy
  ];

  setupPyBuildFlags = [
    "--symengine-dir=${symengine}"
    "--define=\"CYTHON_BIN=${cython}/bin/cython\""
  ];

  checkPhase = ''
    mkdir empty
    cd empty
    ${python.interpreter} ../bin/test_python.py
  '';

  meta = with lib; {
    description = "Python library providing wrappers to SymEngine";
    homepage = https://github.com/symengine/symengine.py;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
