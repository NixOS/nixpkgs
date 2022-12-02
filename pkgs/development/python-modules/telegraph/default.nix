{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, requests
, httpx
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "telegraph";
  version = "2.1.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    repo = "telegraph";
    owner = "python273";
    sha256 = "ChlQJu4kHkXUf4gOtW5HS+ThP3eQL7LsyANeS/10pLo=";
    rev = "da629de7c00c3b8b0c7ab8ef4bf23caf419a3c6c";
  };

  checkInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "tests/" ];

  disabledTests = [
    "test_get_page"
  ];

  doCheck = true;

  propagatedBuildInputs = [
    requests
  ];

  passthru.optional-dependencies = {
    aio = [
      httpx
    ];
  };


  pythonImportsCheck = [ "telegraph" ];

  meta = with lib; {
    homepage = "https://github.com/python273/telegraph";
    description = "Telegraph API wrapper";
    license = licenses.mit;
    maintainers = with maintainers; [ gp2112 ];
  };
}

