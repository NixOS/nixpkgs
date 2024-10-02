{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  sphinx,
}:

buildPythonPackage rec {
  pname = "sphinx-argparse";
  version = "0.5.2";
  format = "setuptools";

  src = fetchPypi {
    pname = "sphinx_argparse";
    inherit version;
    hash = "sha256-5TUvj6iUtvtv2gSYuiip+NQ1lx70u8GmycZBTnZE8DI=";
  };

  postPatch = ''
    # Fix tests for python-3.10 and add 3.10 to CI matrix
    # Should be fixed in versions > 0.3.1
    # https://github.com/ashb/sphinx-argparse/pull/3
    substituteInPlace sphinxarg/parser.py \
      --replace "if action_group.title == 'optional arguments':" "if action_group.title == 'optional arguments' or action_group.title == 'options':"
  '';

  propagatedBuildInputs = [ sphinx ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sphinxarg" ];

  meta = {
    description = "Sphinx extension that automatically documents argparse commands and options";
    homepage = "https://github.com/ashb/sphinx-argparse";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ clacke ];
  };
}
