{ lib
, buildPythonPackage
, fetchpatch
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
  version = "0.9.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "symengine";
    repo = "symengine.py";
    rev = "v${version}";
    hash = "sha256-ZHplYEG97foy/unOdSokFFkDl4LK5TI4kypHSLpcCM4=";
  };

  patches = [
    (fetchpatch {
      # setuptools 61 compat
      url = "https://github.com/symengine/symengine.py/commit/987e665e71cf92d1b021d7d573a1b9733408eecf.patch";
      hash = "sha256-2QbNdw/lKYRIRpOU5BiwF2kK+5Lh2j/Q82MKUIvl0+c=";
    })
  ];

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
    maintainers = [ maintainers.costrouc ];
  };
}
