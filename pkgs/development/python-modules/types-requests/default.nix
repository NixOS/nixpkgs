{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-requests";
  version = "2.25.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Tsi3Hac+U0Stub7nJadOyFmOcob5vLF1ANYn8ln+T7k=";
  };

  # Modules doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "requests-stubs" ];

  meta = with lib; {
    description = "Typing stubs for requests";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
