{ lib
, buildPythonPackage
, fetchPypi
, pytest
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinx-argparse";
  version = "0.2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05wc8f5hb3jsg2vh2jf7jsyan8d4i09ifrz2c8fp6f7x1zw9iav0";
  };

  checkInputs = [
    pytest
  ];

  checkPhase = "py.test";

  propagatedBuildInputs = [
    sphinx
  ];

  meta = {
    description = "A sphinx extension that automatically documents argparse commands and options";
    homepage = https://github.com/ribozz/sphinx-argparse;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ clacke ];
  };
}
