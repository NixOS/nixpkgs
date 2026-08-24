{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "types-toml";
  version = "0.10.8.20260518";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gOEPrNJP3tqdXGchh9cr46woSEN4jWf1quWePgFttv4=";
  };

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "toml-stubs" ];

  meta = {
    description = "Typing stubs for toml";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
