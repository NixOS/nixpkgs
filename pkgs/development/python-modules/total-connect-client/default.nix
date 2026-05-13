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
  zeep,
}:

buildPythonPackage rec {
  pname = "total-connect-client";
  version = "2025.12.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "craigjmidwinter";
    repo = "total-connect-client";
    tag = version;
    hash = "sha256-ofbGW5OCKAFW+BXYvegHmFrnJKmRx/Ez86Na00bp9cw=";
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

  meta = {
    description = "Interact with Total Connect 2 alarm systems";
    homepage = "https://github.com/craigjmidwinter/total-connect-client";
    changelog = "https://github.com/craigjmidwinter/total-connect-client/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
