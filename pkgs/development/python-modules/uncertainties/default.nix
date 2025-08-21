{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # optional-dependencies
  numpy,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "uncertainties";
  version = "3.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lmfit";
    repo = "uncertainties";
    tag = version;
    hash = "sha256-YapujmwTlmUfTQwHsuh01V+jqsBbTd0Q9adGNiE8Go0=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  optional-dependencies.arrays = [ numpy ];

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ optional-dependencies.arrays;

  pythonImportsCheck = [ "uncertainties" ];

  meta = {
    homepage = "https://uncertainties.readthedocs.io/";
    description = "Transparent calculations with uncertainties on the quantities involved (aka error propagation)";
    maintainers = with lib.maintainers; [
      rnhmjoj
      doronbehar
    ];
    license = lib.licenses.bsd3;
  };
}
