{ lib
, buildPythonPackage
, fetchPypi
, types-html5lib
}:

buildPythonPackage rec {
  pname = "types-beautifulsoup4";
  version = "4.12.0.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BFqyhdPlQBhuFhM2EvQ/Z+MfkQ5tdXiQa0OgrY+BE0c=";
  };

  propagatedBuildInputs = [
    types-html5lib
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "bs4-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for beautifulsoup4";
    homepage = "https://pypi.org/project/types-beautifulsoup4/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
