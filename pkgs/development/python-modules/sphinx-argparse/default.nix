{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinx-argparse";
  version = "0.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-5UrWyPiVrGu50N2foH5H4TeipCrhinFFFSYuhrTMS6s=";
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
