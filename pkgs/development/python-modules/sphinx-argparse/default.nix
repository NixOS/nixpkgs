{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinx-argparse";
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "82151cbd43ccec94a1530155f4ad34f251aaca6a0ffd5516d7fadf952d32dc1e";
  };

  postPatch = ''
    # Fix tests for python-3.10 and add 3.10 to CI matrix
    # Should be fixed in versions > 0.3.1
    # https://github.com/ashb/sphinx-argparse/pull/3
    substituteInPlace sphinxarg/parser.py \
      --replace "if action_group.title == 'optional arguments':" "if action_group.title == 'optional arguments' or action_group.title == 'options':"
  '';

  propagatedBuildInputs = [
    sphinx
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "sphinxarg" ];

  meta = {
    description = "A sphinx extension that automatically documents argparse commands and options";
    homepage = "https://github.com/ashb/sphinx-argparse";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ clacke ];
  };
}
