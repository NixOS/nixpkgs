{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  hatchling,
  aiohttp,
}:

buildPythonPackage rec {
  pname = "solarlog-cli";
  version = "0.1.6";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "dontinelli";
    repo = "solarlog_cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-Bliq1n6xH0cZQHueiGDyalIo0zms8zCSpUGq2KH5xZY=";
  };

  build-system = [ hatchling ];

  dependencies = [ aiohttp ];

  pythonImportsCheck = [ "solarlog_cli" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/dontinelli/solarlog_cli/releases/tag/v${version}";
    description = "Python library to access the Solar-Log JSON interface";
    homepage = "https://github.com/dontinelli/solarlog_cli";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
