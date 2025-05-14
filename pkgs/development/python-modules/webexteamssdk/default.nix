{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  future,
  pyjwt,
  pythonOlder,
  requests,
  requests-toolbelt,
  setuptools,
  versioneer,
}:

buildPythonPackage rec {
  pname = "webexteamssdk";
  version = "2.0.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CiscoDevNet";
    repo = "webexteamssdk";
    tag = "v${version}";
    hash = "sha256-E66LwqzNWYAxnB8y5t8JHH4oVVXvheO7tteHWqrRRt8=";
  };

  postPatch = ''
    # Remove vendorized versioneer
    rm versioneer.py
  '';

  build-system = [
    setuptools
    versioneer
  ];

  dependencies = [
    future
    pyjwt
    requests
    requests-toolbelt
  ];

  # Tests require a Webex Teams test domain
  doCheck = false;

  pythonImportsCheck = [ "webexteamssdk" ];

  meta = with lib; {
    description = "Python module for Webex Teams APIs";
    homepage = "https://github.com/CiscoDevNet/webexteamssdk";
    changelog = "https://github.com/WebexCommunity/WebexPythonSDK/releases/tag/${src.tag}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
