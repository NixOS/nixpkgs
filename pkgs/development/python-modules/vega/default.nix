{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  altair,
  ipytablewidgets,
  ipywidgets,
  jupyter,
  jupyter-core,
  jupyterlab,
  pandas,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "vega";
  version = "4.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8lrmhCvwczqBpiQRCkPjmiYsJPHEFnZab/Azkh+i7ls=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  pythonRelaxDeps = [ "pandas" ];

  propagatedBuildInputs = [
    ipytablewidgets
    jupyter
    jupyter-core
    pandas
  ];

  optional-dependencies = {
    widget = [ ipywidgets ];
    jupyterlab = [ jupyterlab ];
  };

  nativeCheckInputs = [
    altair
    pytestCheckHook
  ];

  disabledTestPaths = [
    # these tests are broken with jupyter-notebook >= 7
    "vega/tests/test_entrypoint.py"
  ];

  pythonImportsCheck = [ "vega" ];

  meta = with lib; {
    description = "IPython/Jupyter widget for Vega and Vega-Lite";
    longDescription = ''
      To use this you have to enter a nix-shell with vega. Then run:

      jupyter nbextension install --user --py vega
      jupyter nbextension enable --user vega
    '';
    homepage = "https://github.com/vega/ipyvega";
    license = licenses.bsd3;
    maintainers = with maintainers; [ teh ];
  };
}
