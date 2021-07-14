{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-toml";
  version = "0.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-M+vme+uuxVoSPsuqK9mP5YgzXY2N2ix6xTUC71qBp5o=";
  };

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "toml-stubs" ];

  meta = with lib; {
    description = "Typing stubs for toml";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ veehaitch ];
  };
}
