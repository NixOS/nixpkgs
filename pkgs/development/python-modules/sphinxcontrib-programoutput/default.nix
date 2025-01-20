{
  lib,
  buildPythonPackage,
  fetchPypi,
  sphinx,
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-programoutput";
  version = "0.18";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CeaLZBHZN6gLYIX0/eqkLg3FVVSAOFk4Rl9BBYnS7tg=";
  };

  buildInputs = [ sphinx ];

  # fails to import sphinxcontrib.serializinghtml
  doCheck = false;

  pythonImportsCheck = [ "sphinxcontrib.programoutput" ];

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = with lib; {
    description = "Sphinx extension to include program output";
    homepage = "https://github.com/NextThought/sphinxcontrib-programoutput";
    license = licenses.bsd2;
    maintainers = [ ];
  };
}
