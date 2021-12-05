{ lib, buildPythonPackage, pythonOlder, fetchFromGitHub, python-dateutil
, requests, pytestCheckHook }:

buildPythonPackage rec {
  pname = "srpenergy";
  version = "1.3.5";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "lamoreauxlab";
    repo = "srpenergy-api-client-python";
    rev = version;
    sha256 = "sha256-s90+gzjcG27pUcMGpzf2rf+mR8/fmpvwBXGfvv3rNGI=";
  };

  propagatedBuildInputs = [ python-dateutil requests ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "srpenergy.client" ];

  meta = with lib; {
    description =
      "Unofficial Python module for interacting with Srp Energy data";
    homepage = "https://github.com/lamoreauxlab/srpenergy-api-client-python";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
