{ lib
, buildPythonPackage
, fetchPypi
, docutils
, sphinx
, readthedocs-sphinx-ext
, sphinxcontrib-jquery
, pytestCheckHook
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "sphinx-rtd-theme";
  version = "1.3.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "sphinx_rtd_theme";
    inherit version;
    hash = "sha256-WQsDDHq7nPA47AU7leU4C1xw1hWR6wtVIGP758QfCTE=";
  };

  preBuild = ''
    # Don't use NPM to fetch assets. Assets are included in sdist.
    export CI=1
  '';

  propagatedBuildInputs = [
    docutils
    sphinx
    sphinxcontrib-jquery
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  nativeCheckInputs = [
    pytestCheckHook
    readthedocs-sphinx-ext
  ];

  pythonRelaxDeps = [
    "docutils"
    "sphinxcontrib-jquery"
  ];

  pythonImportsCheck = [
    "sphinx_rtd_theme"
  ];

  meta = with lib; {
    description = "Sphinx theme for readthedocs.org";
    homepage = "https://github.com/readthedocs/sphinx_rtd_theme";
    changelog = "https://github.com/readthedocs/sphinx_rtd_theme/blob/${version}/docs/changelog.rst";
    license = licenses.mit;
  };
}
