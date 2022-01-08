{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-toml";
  version = "0.10.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cd38b802e9c84c7a2e9b61e99a217e794bc01874586b292222e9764c6c7ca75c";
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
