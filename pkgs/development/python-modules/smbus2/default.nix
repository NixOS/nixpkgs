{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "smbus2";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kplindegaard";
    repo = "smbus2";
    tag = version;
    hash = "sha256-GoXSDUmMnrJAfQ8EfCP5bdkq5g0nKLRHcvou5c6vZGU=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "smbus2" ];

  meta = {
    description = "Drop-in replacement for smbus-cffi/smbus-python";
    homepage = "https://smbus2.readthedocs.io/";
    changelog = "https://github.com/kplindegaard/smbus2/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
