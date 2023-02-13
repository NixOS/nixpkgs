{ lib
, buildPythonPackage
, fetchPypi
, types-futures
}:

buildPythonPackage rec {
  pname = "types-protobuf";
  version = "4.21.0.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-gZp8Z+aUduOcPwyYcbu57oIxNkXTF7ba62CslaMJ29M=";
  };

  propagatedBuildInputs = [
    types-futures
  ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "google-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for protobuf";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ andersk ];
  };
}
