{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-toml";
  version = "0.10.8";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-t+fqVyMIsQMNyGw7qCXFIQgUwoJWEuxnnreBT43ZKVo=";
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
