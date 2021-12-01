{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-setuptools";
  version = "57.4.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-o8vL8/AhQrtdO1xfWRj0U7h1I2K5bViroqXPpDum0gk=";
  };

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "setuptools-stubs" ];

  meta = with lib; {
    description = "Typing stubs for setuptools";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
