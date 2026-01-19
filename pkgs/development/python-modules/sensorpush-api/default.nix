{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pydantic,
  pytestCheckHook,
  python-dateutil,
  setuptools,
  urllib3,
}:

buildPythonPackage rec {
  pname = "sensorpush-api";
  version = "2.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sstallion";
    repo = "sensorpush-api";
    tag = "v${version}";
    hash = "sha256-T/qROLlzgiRN4T8lwyXoD/8EtTqQY2+D8AXNKu5MeNE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    pydantic
    python-dateutil
    urllib3
  ];

  pythonImportsCheck = [ "sensorpush_api" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/sstallion/sensorpush-api/blob/${src.tag}/CHANGELOG.md";
    description = "SensorPush Public API for Python";
    homepage = "https://github.com/sstallion/sensorpush-api";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
