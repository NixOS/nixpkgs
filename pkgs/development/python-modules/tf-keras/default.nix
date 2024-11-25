{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  numpy,
  tensorflow,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "tf-keras";
  version = "2.17.0";
  pyproject = true;

  src = fetchPypi {
    pname = "tf_keras";
    inherit version;
    hash = "sha256-/al8GNow2g9ypafoDz7uNDsJ9MIG2tbFfJRPss0YVg4=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    tensorflow
  ];

  pythonImportsCheck = [ "tf_keras" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Deep learning for humans";
    homepage = "https://pypi.org/project/tf-keras/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
