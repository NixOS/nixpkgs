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
  version = "2.0.3";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "WebexCommunity";
    repo = "WebexPythonSDK";
    tag = "v${version}";
    hash = "sha256-E66LwqzNWYAxnB8y5t8JHH4oVVXvheO7tteHWqrRRt8=";
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
