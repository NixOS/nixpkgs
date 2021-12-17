{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, zeep
}:

buildPythonPackage rec {
  pname = "total-connect-client";
  version = "2021.11.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "craigjmidwinter";
    repo = "total-connect-client";
    rev = version;
    sha256 = "sha256-6hyeU0jigQZsZtdb4E8/iD8YfQeNOKm6IK1CHBizZQs=";
  };

  propagatedBuildInputs = [
    zeep
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "total_connect_client"
  ];

  meta = with lib; {
    description = "Interact with Total Connect 2 alarm systems";
    homepage = "https://github.com/craigjmidwinter/total-connect-client";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
