{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  setuptools,
  wheel,
  numpy,
  tensorflow-bin,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "tf-keras";
  version = "2.17.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "tf_keras";
    inherit version;
    hash = "sha256-/al8GNow2g9ypafoDz7uNDsJ9MIG2tbFfJRPss0YVg4=";
  };

  postPatch = ''
    # Remove dependencies
    substituteInPlace setup.py \
      --replace-fail "install_requires=install_requires," ""
  '';

  pythonRelaxDeps = [
    "tensorflow"
  ];

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    numpy
    tensorflow-bin
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
