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
  pname = "webexteamssdk";
  version = "2.0.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "CiscoDevNet";
    repo = "webexteamssdk";
    rev = "refs/tags/v${version}";
    hash = "sha256-ENAUUicVO/Br7k+RFHCGzQ7BIG0CP7jTYM3tzs5EAZQ=";
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
    homepage = "https://github.com/CiscoDevNet/webexteamssdk";
    changelog = "https://github.com/WebexCommunity/WebexPythonSDK/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
