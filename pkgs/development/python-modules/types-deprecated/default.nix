{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-deprecated";
  version = "1.2.9.2";
  format = "setuptools";

  src = fetchPypi {
    pname = "types-Deprecated";
    inherit version;
    hash = "sha256-kWFv1nRfi/LUV/u779FM3kODjp8AoEtaDq5Pwfe7xpc=";
  };

  # Modules has no tests
  doCheck = false;

  pythonImportsCheck = [
    "deprecated-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for Deprecated";
    homepage = "https://pypi.org/project/types-Deprecated/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
