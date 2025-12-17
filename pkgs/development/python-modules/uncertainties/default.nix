{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

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

  patches = [
    (fetchpatch {
      # python 3.14 compat
      url = "https://github.com/lmfit/uncertainties/commit/633da70494ae6570cc69a910e1f6231538acf374.patch";
      hash = "sha256-P1LiIqA2p58bjupJaf18A6YxBeu+PNpueHACry24OwQ=";
    })
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  optional-dependencies.arrays = [ numpy ];

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ optional-dependencies.arrays;

  disabledTests = [
    # Flaky tests, see: https://github.com/lmfit/uncertainties/issues/343
    "test_repeated_summation_complexity"
  ];

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
