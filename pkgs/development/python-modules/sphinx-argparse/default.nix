{ lib
, buildPythonPackage
, fetchPypi
, pytest
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinx-argparse";
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "82151cbd43ccec94a1530155f4ad34f251aaca6a0ffd5516d7fadf952d32dc1e";
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
    homepage = "https://github.com/ribozz/sphinx-argparse";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ clacke ];
  };
}
