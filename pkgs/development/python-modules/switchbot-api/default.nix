{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "switchbot-api";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "SeraphicCorp";
    repo = "py-switchbot-api";
    rev = "refs/tags/v${version}";
    hash = "sha256-QM8oVfd+hdVNdhOgI3ujyY82Im0Yr5Nl+OcqzEtZ7XE=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  # Module has no tests
  doCheck= false;

  pythonImportsCheck = [
    "switchbot_api"
  ];

  meta = with lib; {
    description = "An asynchronous library to use Switchbot API";
    homepage = "https://github.com/SeraphicCorp/py-switchbot-api";
    changelog = "https://github.com/SeraphicCorp/py-switchbot-api/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
