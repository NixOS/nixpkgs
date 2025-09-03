{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  numpy,
  tensorflow,
  pythonAtLeast,
  distutils,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "tf-keras";
  version = "2.19.0";
  pyproject = true;

  src = fetchPypi {
    pname = "tf_keras";
    inherit version;
    hash = "sha256-sJpAfYekVxzh6MqYXPxoSD49Y7JRil15qXrZLLZNvpw=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    tensorflow
  ]
  ++ lib.optionals (pythonAtLeast "3.12") [ distutils ];

  pythonImportsCheck = [ "tf_keras" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Deep learning for humans";
    homepage = "https://pypi.org/project/tf-keras/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
