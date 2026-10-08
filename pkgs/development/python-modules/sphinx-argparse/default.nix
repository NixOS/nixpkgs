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
  version = "0.6.0";
  pyproject = true;

  src = fetchPypi {
    pname = "sphinx_argparse";
    inherit version;
    hash = "sha256-0HK7Z91SspQ3Xw7twgPLjlDQMpkQ2862dk6Thr/5Tp0=";
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
