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
  version = "2.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sstallion";
    repo = "sensorpush-api";
    tag = "v${version}";
    hash = "sha256-Gkvd0MbySk4jdl+hJd0wFGqj2/qOkq/jThe+5b4n0XM=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "urllib3"
  ];

  pythonRemoveDeps = [
    "aenum" # https://github.com/sstallion/sensorpush-api/pull/3
  ];

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
