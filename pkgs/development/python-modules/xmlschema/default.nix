{ lib
, buildPythonPackage
, fetchFromGitHub
, elementpath
, jinja2
, lxml
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "xmlschema";
<<<<<<< HEAD
  version = "2.3.1";
=======
  version = "2.2.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sissaschool";
    repo = "xmlschema";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-0xXA3IguVAyFp5dFvuzAQhzJlGMmNthmPXcja9FYV44=";
=======
    hash = "sha256-KTxVUYdflHiC96tALFcMA0JnLt0vj/nSD3ie53lMi50=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    elementpath
  ];

  nativeCheckInputs = [
    jinja2
    lxml
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "xmlschema"
  ];

  meta = with lib; {
    changelog = "https://github.com/sissaschool/xmlschema/blob/${src.rev}/CHANGELOG.rst";
    description = "XML Schema validator and data conversion library for Python";
    homepage = "https://github.com/sissaschool/xmlschema";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
