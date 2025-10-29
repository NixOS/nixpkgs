{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pycryptodome,
  pyjwt,
  pytestCheckHook,
  pythonOlder,
  requests-mock,
  requests-oauthlib,
  setuptools,
  zeep,
}:

buildPythonPackage rec {
  pname = "total-connect-client";
  version = "2025.5";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "craigjmidwinter";
    repo = "total-connect-client";
    tag = version;
    hash = "sha256-xVpR5gd185eZBoqUhVVcFGPbPFjCavwOZP7yFObzGic=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "pycryptodome" ];

  dependencies = [
    pycryptodome
    pyjwt
    requests-oauthlib
    zeep
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "total_connect_client" ];

  meta = with lib; {
    description = "Interact with Total Connect 2 alarm systems";
    homepage = "https://github.com/craigjmidwinter/total-connect-client";
    changelog = "https://github.com/craigjmidwinter/total-connect-client/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
