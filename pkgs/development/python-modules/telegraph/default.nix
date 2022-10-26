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
  version = "2.2.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    repo = "telegraph";
    owner = "python273";
    sha256 = "xARX8lSOftNVYY4InR5vU4OiguCJJJZv/W76G9eLgNY=";
    rev = "v${version}";
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

