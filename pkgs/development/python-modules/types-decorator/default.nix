{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-decorator";
  version = "0.1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rfg2s4y23w1xk0502sg2jqbzswalkg6infblyzgf94i4bsg1j48";
  };

  # Modules doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "decorator-stubs" ];

  meta = with lib; {
    description = "Typing stubs for decorator";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
