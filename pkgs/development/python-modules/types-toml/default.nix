{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-toml";
  version = "0.10.8.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-v4D859LXS+kRSPR7iNmuWt6xAkq+8iqi/bq8A21rizw=";
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
