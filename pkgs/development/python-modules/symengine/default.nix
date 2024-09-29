{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
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

  patches = [
    # Distutils has been removed in python 3.12
    # See https://github.com/symengine/symengine.py/pull/478
    (fetchpatch {
      name = "no-distutils.patch";
      url = "https://github.com/symengine/symengine.py/pull/478/commits/e72006d5f7425cd50c54b22766e0ed4bcd2dca85.patch";
      hash = "sha256-kGJRGkBgxOfI1wf88JwnSztkOYd1wvg62H7wA6CcYEQ=";
    })
  ];

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
