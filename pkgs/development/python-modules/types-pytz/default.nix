{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-pytz";
  version = "2021.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-xO42Rm+u2a8zTRUJPQXOpBYyPS0EMVi7WCu5TAQav1E=";
  };

  # Modules doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "pytz-stubs" ];

  meta = with lib; {
    description = "Typing stubs for pytz";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
