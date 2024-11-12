{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  scikit-build-core,
  setuptools,
  setuptools-scm,
  cmake,
  ninja,
  matchpy,
  numpy,
  astunparse,
  typing-extensions,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "uarray";
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Quansight-Labs";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-q9lMU/xA+G2x38yZy3DxCpXTEmg1lZhZ8GFIHDIKE24=";
  };

  build-system = [
    scikit-build-core
    setuptools
    setuptools-scm
    cmake
    ninja
  ];

  dontUseCmakeConfigure = true;

  dependencies = [
    astunparse
    matchpy
    numpy
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  # Tests must be run from outside the source directory
  preCheck = ''
    cd $TMP
  '';

  pytestFlagsArray = [
    "--pyargs"
    "uarray"
  ];

  pythonImportsCheck = [ "uarray" ];

  meta = with lib; {
    description = "Universal array library";
    homepage = "https://github.com/Quansight-Labs/uarray";
    license = licenses.bsd0;
    maintainers = [ lib.maintainers.pbsds ];
  };
}
