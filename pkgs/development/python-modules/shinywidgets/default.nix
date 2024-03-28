{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# setup requires
, setuptools

# install requires
, ipywidgets
, jupyter-core
, shiny
, python-dateutil
, importlib-metadata
}:

buildPythonPackage rec {
  pname = "shinywidgets";
  version = "0.2.0";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rstudio";
    repo = "py-shinywidgets";
    rev = "v${version}";
    hash = "sha256-D7Xdho74IIOR0b2v5ScRZoevhnBeWExDxwu40XjnSuc=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    ipywidgets
    jupyter-core
    shiny
    python-dateutil
    importlib-metadata
  ];

  # no unit tests as of 0.2.0
  doCheck = false;

  pythonImportsCheck = [ "shinywidgets" ];

  meta = with lib; {
    homepage = "https://github.com/rstudio/py-shinywidgets";
    description = "Render ipywidgets inside a Shiny app.";
    license = licenses.mit;
    maintainers = with maintainers; [ nviets ];
    platforms = platforms.unix;
  };
}
