{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-html5lib";
  version = "1.1.11.15";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gOGiBi0io6/+XCjZfaML/786B205PID8bxZxIWwb1JI=";
  };

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "html5lib-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for html5lib";
    homepage = "https://pypi.org/project/types-html5lib/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
