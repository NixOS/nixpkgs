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
  version = "1.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sstallion";
    repo = "sensorpush-ha";
    tag = "v${version}";
    hash = "sha256-BsNPON2jYeqddd4vZF7SUhaXFT6AzPitcqL1sI/St/A=";
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
