{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyjwt,
  pythonOlder,
  requests,
  requests-toolbelt,
  poetry-core,
  poetry-dynamic-versioning,
}:

buildPythonPackage rec {
  pname = "webexpythonsdk";
  version = "2.0.4";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "WebexCommunity";
    repo = "WebexPythonSDK";
    tag = "v${version}";
    hash = "sha256-8U3aAS+9dU5Zg4fS2t6zLvTEJ/6aIV/YEWte06GvKTo=";
  };

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = [
    pyjwt
    requests
    requests-toolbelt
  ];

  # Tests require a Webex Teams test domain
  doCheck = false;

  pythonImportsCheck = [ "webexpythonsdk" ];

  meta = with lib; {
    description = "Python module for Webex Teams APIs";
    homepage = "https://github.com/WebexCommunity/WebexPythonSDK";
    changelog = "https://github.com/WebexCommunity/WebexPythonSDK/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
