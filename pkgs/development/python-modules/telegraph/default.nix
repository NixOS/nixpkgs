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
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    repo = "telegraph";
    owner = "python273";
    rev = "refs/tags/v${version}";
    hash = "sha256-xARX8lSOftNVYY4InR5vU4OiguCJJJZv/W76G9eLgNY=";
  };

  propagatedBuildInputs = [
    requests
  ];

  passthru.optional-dependencies = {
    aio = [
      httpx
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "tests/"
  ];

  disabledTests = [
    "test_get_page"
  ];

  doCheck = true;

  pythonImportsCheck = [
    "telegraph"
  ];

  meta = with lib; {
    description = "Telegraph API wrapper";
    homepage = "https://github.com/python273/telegraph";
    changelog = "https://github.com/python273/telegraph/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ gp2112 ];
  };
}

