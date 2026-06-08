{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "timecop";
  version = "0.5.0dev";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jYcA3gByT5RydMU8eK+PUnWe9TrRQ/chw+F6wTUqcX0=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ unittestCheckHook ];

  # test_epoch fails, see https://github.com/bluekelp/pytimecop/issues/4
  preCheck = ''
    sed -i 's/test_epoch/_test_epoch/' timecop/tests/test_freeze.py
  '';

  pythonImportsCheck = [ "timecop" ];

  meta = {
    description = "Port of the most excellent TimeCop Ruby Gem for Python";
    homepage = "https://github.com/bluekelp/pytimecop";
    license = lib.licenses.gpl3Plus;
  };
}
