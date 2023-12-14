{ lib
, buildPythonPackage
, fetchPypi
, types-html5lib
}:

buildPythonPackage rec {
  pname = "types-beautifulsoup4";
  version = "4.12.0.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WZgAKNKb9V0Ns1nvowW3W6zwy5Lj8/az/UCPJTHfJ0w=";
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
