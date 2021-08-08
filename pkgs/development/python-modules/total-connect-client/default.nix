{ lib
, buildPythonPackage
, fetchFromGitHub
, zeep
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "total-connect-client";
  version = "0.58";

  src = fetchFromGitHub {
    owner = "craigjmidwinter";
    repo = "total-connect-client";
    rev = version;
    sha256 = "1dqmgvgvwjh235wghygan2jnfvmn9vz789in2as3asig9cifix9z";
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

  pythonImportsCheck = [ "total_connect_client" ];

  meta = with lib; {
    description = "Interact with Total Connect 2 alarm systems";
    homepage = "https://github.com/craigjmidwinter/total-connect-client";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
