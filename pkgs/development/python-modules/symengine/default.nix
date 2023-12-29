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
  version = "0.10.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "symengine";
    repo = "symengine.py";
    rev = "refs/tags/v${version}";
    hash = "sha256-03lHip0iExfptrUe5ObA6xXrsfS4QJPrh1Z0v7q2lDI=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "\"cmake\"" "\"${cmake}/bin/cmake\"" \
      --replace "'cython>=0.29.24'" "'cython'"
  '';

  nativeBuildUnputs = [ cmake ];

  buildInputs = [ cython ];

  nativeCheckInputs = [ pytest sympy ];

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
    maintainers = [ ];
  };
}
