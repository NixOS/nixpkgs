{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-toml";
  version = "0.10.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-k0DnwVh3FVgbsTkFs68wt5/mivrM/KN3Zl1eY7aUEpo=";
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
