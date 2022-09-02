{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "webcolors";
  version = "1.12";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FtBD06CP1qGxt+Pp5iZA0JeQ3OgNK91HkqF1s1/nlKk=";
  };

  checkInputs = [ unittestCheckHook ];

  unittestFlagsArray = [ "-s" "tests" ];

  pythonImportsCheck = [
    "webcolors"
  ];

  meta = with lib; {
    description = "Library for working with color names/values defined by the HTML and CSS specifications";
    homepage = "https://github.com/ubernostrum/webcolors";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
