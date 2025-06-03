{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  sphinx,
  pytestCheckHook,
  lxml,
}:

buildPythonPackage rec {
  pname = "sphinx-argparse";
  version = "0.5.2";
  pyproject = true;

  src = fetchPypi {
    pname = "sphinx_argparse";
    inherit version;
    hash = "sha256-5TUvj6iUtvtv2gSYuiip+NQ1lx70u8GmycZBTnZE8DI=";
  };

  build-system = [ flit-core ];

  dependencies = [ sphinx ];

  nativeCheckInputs = [
    lxml
    pytestCheckHook
  ];

  pythonImportsCheck = [ "sphinxarg" ];

  meta = {
    description = "Sphinx extension that automatically documents argparse commands and options";
    homepage = "https://github.com/ashb/sphinx-argparse";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ clacke ];
  };
}
