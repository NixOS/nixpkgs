{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, zeep
}:

buildPythonPackage rec {
  pname = "total-connect-client";
  version = "2021.11.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "craigjmidwinter";
    repo = "total-connect-client";
    rev = version;
    sha256 = "sha256-iggxKefrVZP4ljf8jGRrCAq0/xQLsr54L42KkdjBqgI=";
  };

  propagatedBuildInputs = [
    zeep
  ];

  checkInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    export PYTHONPATH="total_connect_client:$PYTHONPATH"
  '';

  disabledTests = [
    # Tests require network access
    "tests_request"
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
