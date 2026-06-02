{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  setuptools,
  cmake,
  symengine,
  pytest,
  sympy,
  python,
}:

buildPythonPackage rec {
  pname = "symengine";
  version = "0.14.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "symengine";
    repo = "symengine.py";
    tag = "v${version}";
    hash = "sha256-adzODm7gAqwAf7qzfRQ1AG8mC3auiXM4OsV/0h+ZmUg=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "'cython>=0.29.24'" "'cython'"
  '';

  build-system = [
    cython
    setuptools
  ];

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    symengine
  ];

  nativeCheckInputs = [
    pytest
    sympy
  ];

  checkPhase = ''
    runHook preCheck

    mkdir empty && cd empty
    ${python.interpreter} ../bin/test_python.py

    runHook postCheck
  '';

  meta = {
    description = "Python library providing wrappers to SymEngine";
    homepage = "https://github.com/symengine/symengine.py";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
