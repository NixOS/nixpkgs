{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pythonRelaxDepsHook
, altair
, ipytablewidgets
, ipywidgets
, jupyter
, jupyter-core
, jupyterlab
, pandas
, poetry-core
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "vega";
  version = "4.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-v1/8taHdN1n9+gy7L+g/wAJ2x9FwYCaxZiEdFqLct1Y=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "poetry.masonry.api" "poetry.core.masonry.api"
  '';

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "pandas"
  ];

  propagatedBuildInputs = [
    ipytablewidgets
    jupyter
    jupyter-core
    pandas
  ];

  passthru.optional-dependencies = {
    widget = [
      ipywidgets
    ];
    jupyterlab = [
      jupyterlab
    ];
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
    description = "An IPython/Jupyter widget for Vega and Vega-Lite";
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
