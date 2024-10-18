{
  lib,
  buildPythonPackage,
  fetchpatch,
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

  patches = [
    # https://github.com/vega/ipyvega/pull/507
    (fetchpatch {
      name = "replace-poetry-with-poetry-core.patch";
      url = "https://github.com/vega/ipyvega/commit/1a5028ee5d54e24b9650b66685f54c42b72c7899.patch";
      hash = "sha256-W8UmMit7DJGKCM9+/OSRLTuRvC0ZR42AP/b/frVEvsk=";
    })
  ];

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
