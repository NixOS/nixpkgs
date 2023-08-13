{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-psutil";
  version = "5.9.5.16";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TpshnvtiXT0E9r8QaTT4fKtJqkGpSwo7MIlAP0enkig=";
  };

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "psutil-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for psutil";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ anselmschueler ];
  };
}
