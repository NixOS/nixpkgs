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
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "symengine";
    repo = "symengine.py";
    rev = "v${version}";
    sha256 = "13fy25qxn4xwzlr2w35v6jhlpd70lv9r6srv4dizc4brj63hnw50";
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
