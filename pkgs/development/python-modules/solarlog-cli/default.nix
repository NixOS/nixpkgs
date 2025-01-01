{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  hatchling,
  aiohttp,
  mashumaro,
  aioresponses,
  pytest-aio,
  pytestCheckHook,
  syrupy,
}:

buildPythonPackage rec {
  pname = "solarlog-cli";
  version = "0.3.0";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "dontinelli";
    repo = "solarlog_cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-jNvwSh89Ncl/rR/cUNVbJfJThJTa9JlANjvH/vRruAU=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    mashumaro
  ];

  pythonImportsCheck = [ "solarlog_cli" ];

  nativeCheckInputs = [
    aioresponses
    pytest-aio
    pytestCheckHook
    syrupy
  ];

  meta = {
    changelog = "https://github.com/dontinelli/solarlog_cli/releases/tag/v${version}";
    description = "Python library to access the Solar-Log JSON interface";
    homepage = "https://github.com/dontinelli/solarlog_cli";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
