{ lib
, fetchFromGitHub
, buildPythonPackage
, authlib
, requests
, nose
, pyjwt
, pythonOlder
, pytz
, responses
, zeep
}:

buildPythonPackage rec {
  pname = "simple-salesforce";
<<<<<<< HEAD
  version = "1.12.4";
=======
  version = "1.12.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-nYL2kSDS6DSrBzAKbg7Wj6boSZ52+T/yX+NYnYQ9rQo=";
=======
    hash = "sha256-lCZdX+gf9ROU1MIRw/ppTNO8jIGUxE1+gbHh6sK5L2s=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    authlib
    pyjwt
    requests
    zeep
  ];

  nativeCheckInputs = [
    nose
    pytz
    responses
  ];

  checkPhase = ''
    runHook preCheck
    nosetests -v
    runHook postCheck
  '';

  pythonImportsCheck = [
    "simple_salesforce"
  ];

  meta = with lib; {
    description = "A very simple Salesforce.com REST API client for Python";
    homepage = "https://github.com/simple-salesforce/simple-salesforce";
    changelog = "https://github.com/simple-salesforce/simple-salesforce/blob/v${version}/CHANGES";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

}
