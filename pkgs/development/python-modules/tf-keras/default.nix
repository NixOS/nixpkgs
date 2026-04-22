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

buildPythonPackage (finalAttrs: {
  pname = "tf-keras";
  inherit (tensorflow) version;
  pyproject = true;

  src = fetchPypi {
    pname = "tf_keras";
    inherit (finalAttrs) version;
    hash = "sha256-+a8PJUbNVTLeD656SB80ocoiU3N9TNEAD2txPccz93A=";
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
})
