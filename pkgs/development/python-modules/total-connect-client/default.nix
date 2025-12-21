{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pycryptodome,
  pyjwt,
  pytestCheckHook,
  requests-mock,
  requests-oauthlib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "total-connect-client";
  version = "2025.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "craigjmidwinter";
    repo = "total-connect-client";
    tag = version;
    hash = "sha256-rfU772UAXd76q/1ewEpsScGOLwJ5r3knYsArYVHKd/s=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pycryptodome
    requests-oauthlib
  ];

  nativeCheckInputs = [
    pyjwt
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "total_connect_client" ];

  meta = {
    description = "Interact with Total Connect 2 alarm systems";
    homepage = "https://github.com/craigjmidwinter/total-connect-client";
    changelog = "https://github.com/craigjmidwinter/total-connect-client/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
