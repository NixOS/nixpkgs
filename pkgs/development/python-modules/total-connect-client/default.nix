{ lib
, buildPythonPackage
, fetchFromGitHub
, zeep
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "total-connect-client";
  version = "2021.8.3";

  src = fetchFromGitHub {
    owner = "craigjmidwinter";
    repo = "total-connect-client";
    rev = version;
    sha256 = "sha256-2iTH/Him4iMZadkmBR8Rwlt3RCqDXzR6ZqNHciNiHIk=";
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

  pythonImportsCheck = [ "total_connect_client" ];

  meta = with lib; {
    description = "Interact with Total Connect 2 alarm systems";
    homepage = "https://github.com/craigjmidwinter/total-connect-client";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
