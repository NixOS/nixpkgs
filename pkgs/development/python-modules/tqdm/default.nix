{ lib
, buildPythonPackage
, fetchPypi
, nose
, coverage
, glibcLocales
, flake8
, setuptools_scm
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "tqdm";
  version = "4.54.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5c0d04e06ccc0da1bd3fa5ae4550effcce42fcad947b4a6cafa77bdc9b09ff22";
  };

  nativeBuildInputs = [
    setuptools_scm
  ];

  checkInputs = [ nose coverage glibcLocales flake8 pytestCheckHook ];

  # Remove performance testing.
  # Too sensitive for on Hydra.
  PYTEST_ADDOPTS = "-k \"not perf\"";

  LC_ALL="en_US.UTF-8";

  meta = {
    description = "A Fast, Extensible Progress Meter";
    homepage = "https://github.com/tqdm/tqdm";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fridh ];
  };
}
