{
  aiohttp,
  aioresponses,
  buildPythonPackage,
  dataclasses-json,
  fetchFromGitHub,
  lib,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "simplefin4py";
  version = "0.0.18";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jeeftor";
    repo = "SimpleFin4py";
    rev = "refs/tags/v${version}";
    hash = "sha256-S+E2zwvrXN0YDY6IxplG0D15zSoeUPMyQt2oyM3QB2Q=";
  };

  build-system = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    dataclasses-json
  ];

  pythonImportsCheck = [ "simplefin4py" ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # fails in non-UTC time zones
    "test_dates"
  ];

  meta = {
    changelog = "https://github.com/jeeftor/simplefin4py/releases/tag/v${version}";
    description = "Python API for Accessing SimpleFIN";
    homepage = "https://github.com/jeeftor/SimpleFin4py";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
