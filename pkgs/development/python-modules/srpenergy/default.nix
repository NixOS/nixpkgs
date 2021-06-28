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
  version = "1.3.2";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "lamoreauxlab";
    repo = "srpenergy-api-client-python";
    rev = version;
    sha256 = "03kldjk90mrnzf2hpd7xky0lpph853mjxc34kfa2m5mbpbpkxz9c";
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
