{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  cmake,
  symengine,
  pytest,
  sympy,
  python,
  setuptools,
}:

buildPythonPackage rec {
  pname = "symengine";
  version = "0.13.0";

  build-system = [ setuptools ];
  pyproject = true;

  src = fetchFromGitHub {
    owner = "symengine";
    repo = "symengine.py";
    rev = "refs/tags/v${version}";
    hash = "sha256-PJUzA86SGCnDpqU9j/dr3PlM9inyi8SQX0HGqPQ9wQw=";
  };

  env = {
    SymEngine_DIR = "${symengine}";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "'cython>=0.29.24'" "'cython'"

    export PATH=${cython}/bin:$PATH
  '';

  dontUseCmakeConfigure = true;
  nativeBuildInputs = [ cmake ];

  buildInputs = [ cython ];

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

  meta = with lib; {
    description = "Python library providing wrappers to SymEngine";
    homepage = "https://github.com/symengine/symengine.py";
    license = licenses.mit;
    maintainers = [ ];
  };
}
