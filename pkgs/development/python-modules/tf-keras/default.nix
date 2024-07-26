{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  setuptools,
  wheel,
  numpy,
  tensorflow,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "tf-keras";
  version = "2.16.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "tf_keras";
    inherit version;
    hash = "sha256-21OJHxrJgZfCrM7ZjNyowGuoJVZVpst+uV7UlnYRgoA=";
  };

  nativeBuildInputs = [
  ];

  pythonRelaxDeps = [
    "tensorflow"
  ];

  build-system = [
    setuptools
    wheel
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
