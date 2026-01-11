{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  scikit-build-core,
  numpy,
  cmake,
  ninja,
  setuptools-scm,

  # dependencies
  typing-extensions,

  # tests
  pytestCheckHook,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "spglib";
  version = "2.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "spglib";
    repo = "spglib";
    tag = "v${version}";
    hash = "sha256-rmQYFFfpyUhT9pfQZk1fN5tZWTg40wwtszhPhiZpXs4=";
  };

  build-system = [
    scikit-build-core
    numpy
    cmake
    ninja
    setuptools-scm
  ];

  dontUseCmakeConfigure = true;

  dependencies = [
    numpy
  ]
  ++ lib.optionals (pythonOlder "3.13") [
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
  ];

  pythonImportsCheck = [ "spglib" ];

  meta = {
    description = "Python bindings for C library for finding and handling crystal symmetries";
    homepage = "https://spglib.github.io/spglib/";
    changelog = "https://github.com/spglib/spglib/raw/v${version}/ChangeLog";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ psyanticy ];
  };
}
