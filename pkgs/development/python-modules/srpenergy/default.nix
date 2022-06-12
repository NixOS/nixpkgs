{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, python-dateutil
, requests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "srpenergy";
  version = "1.3.6";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "lamoreauxlab";
    repo = "srpenergy-api-client-python";
    rev = version;
    hash = "sha256-aZnqGtfklWgigac2gdkQv29Qy5HC34zGGY2iWr2cOMo=";
  };

  propagatedBuildInputs = [
    python-dateutil
    requests
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "srpenergy.client" ];

  meta = with lib; {
    description = "Unofficial Python module for interacting with Srp Energy data";
    homepage = "https://github.com/lamoreauxlab/srpenergy-api-client-python";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
