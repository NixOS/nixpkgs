{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-requests";
  version = "2.26.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1j+mF4Rtzv/1qi1Z5Hq0/9gG5LsFZxFfetu15DgwL+Q=";
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
