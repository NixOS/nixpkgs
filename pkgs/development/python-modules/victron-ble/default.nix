{
  lib,
  bleak,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  pycryptodome,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "victron-ble";
  version = "0.9.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "keshavdv";
    repo = "victron-ble";
    tag = "v${version}";
    hash = "sha256-ALdNM6U9bEX/KHcQu+7vM8Z42dEdxYtuxQRZMf10DyI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    bleak
    click
    pycryptodome
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "victron_ble" ];

  meta = {
    description = "Python library to parse Instant Readout advertisement data from Victron devices";
    homepage = "https://github.com/keshavdv/victron-ble";
    changelog = "https://github.com/keshavdv/victron-ble/releases/tag/${src.tag}";
    license = lib.licenses.unlicense;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
