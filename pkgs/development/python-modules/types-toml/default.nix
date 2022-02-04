{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-toml";
  version = "0.10.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "215a7a79198651ec5bdfd66193c1e71eb681a42f3ef7226c9af3123ced62564a";
  };

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "toml-stubs" ];

  meta = with lib; {
    description = "Typing stubs for toml";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
