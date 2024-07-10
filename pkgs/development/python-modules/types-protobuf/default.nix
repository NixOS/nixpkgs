{
  lib,
  buildPythonPackage,
  fetchPypi,
  types-futures,
}:

buildPythonPackage rec {
  pname = "types-protobuf";
  version = "5.26.0.20240422";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5gdBeBCfl+/p8LIKA1umHXw7A+hn60fSVNKyq2qAXjY=";
  };

  propagatedBuildInputs = [ types-futures ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "google-stubs" ];

  meta = with lib; {
    description = "Typing stubs for protobuf";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ andersk ];
  };
}
