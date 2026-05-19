{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "tilt-pi";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "michaelheyman";
    repo = "tilt-pi";
    tag = "v${version}";
    hash = "sha256-jGy7nwSblF486ldt4ShBEmmZtb0c4+7IuI10cN7Bw1A=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
  ];

  pythonImportsCheck = [ "tiltpi" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/michaelheyman/tilt-pi/releases/tag/${src.tag}";
    description = "Python client for interacting with the Tilt Pi API";
    homepage = "https://github.com/michaelheyman/tilt-pi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
