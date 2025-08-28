{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  pyspark,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "skyboxremote";
  version = "0.0.6";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GgRUMGnU91UQm9LNctYhHfRmfFujfc8fXc9KSwLrNBM=";
  };

  build-system = [ flit-core ];

  optional-dependencies = {
    spark = [
      pyspark
    ];
  };

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "skyboxremote" ];

  meta = {
    description = "Module for controlling a sky box";
    homepage = "https://pypi.org/project/skyboxremote/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
