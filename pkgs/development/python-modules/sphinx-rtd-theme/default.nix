{
  lib,
  buildPythonPackage,
  fetchPypi,
  docutils,
  sphinx,
  readthedocs-sphinx-ext,
  sphinxcontrib-jquery,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sphinx-rtd-theme";
  version = "3.0.2";
  format = "setuptools";

  src = fetchPypi {
    pname = "sphinx_rtd_theme";
    inherit version;
    hash = "sha256-t0V7wl3acjsgsIamcLmVPIWeq2CioD7o6yuyPhduX4U=";
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

  nativeCheckInputs = [
    pytestCheckHook
    readthedocs-sphinx-ext
  ];

  disabledTests = [
    # docutils 0.21 compat
    "test_basic"
  ];

  pythonRelaxDeps = [
    "docutils"
    "sphinxcontrib-jquery"
  ];

  pythonImportsCheck = [ "sphinx_rtd_theme" ];

  meta = with lib; {
    description = "Sphinx theme for readthedocs.org";
    homepage = "https://github.com/readthedocs/sphinx_rtd_theme";
    changelog = "https://github.com/readthedocs/sphinx_rtd_theme/blob/${version}/docs/changelog.rst";
    license = licenses.mit;
  };
}
