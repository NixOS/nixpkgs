{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pydantic,
  sensorpush-api,
  setuptools,
}:

buildPythonPackage rec {
  pname = "sensorpush-ha";
  version = "1.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sstallion";
    repo = "sensorpush-ha";
    tag = "v${version}";
    hash = "sha256-Gs6WprGscr9fiu78S0OY6624LA87Of7OWkNNnaWIxJk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pydantic
    sensorpush-api
  ];

  pythonImportsCheck = [ "sensorpush_ha" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/sstallion/sensorpush-ha/blob/${src.tag}/CHANGELOG.md";
    description = "SensorPush Cloud Home Assistant Library";
    homepage = "https://github.com/sstallion/sensorpush-ha";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
