{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  zeep,
}:

buildPythonPackage rec {
  pname = "total-connect-client";
  version = "2024.12";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "craigjmidwinter";
    repo = "total-connect-client";
    tag = version;
    hash = "sha256-Pf1OFWbulrJeoWSJdI2QQ/ETd5TV6m8uhvCoKsx0bx8=";
  };

  build-system = [ setuptools ];

  dependencies = [ zeep ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "total_connect_client" ];

  meta = with lib; {
    description = "Interact with Total Connect 2 alarm systems";
    homepage = "https://github.com/craigjmidwinter/total-connect-client";
    changelog = "https://github.com/craigjmidwinter/total-connect-client/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
