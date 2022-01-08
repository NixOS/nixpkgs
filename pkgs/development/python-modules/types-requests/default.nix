{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-requests";
  version = "2.27.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c902c5433ad103053011c6ac036317ac6f6a8e8a6926fc470a8d2ef791236da7";
  };

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "requests-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for requests";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
