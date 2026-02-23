{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  docutils,
  sphinx,
  sphinxcontrib-jquery,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sphinx-rtd-theme";
  version = "3.1.0";
  pyproject = true;

  src = fetchPypi {
    pname = "sphinx_rtd_theme";
    inherit version;
    hash = "sha256-tEJ28sJ26Qkjmk9slVqmZ6qv63hZeSOxxgurx223jkw=";
  };

  build-system = [ setuptools ];

  preBuild = ''
    # Don't use NPM to fetch assets. Assets are included in sdist.
    export CI=1
  '';

  dependencies = [
    docutils
    sphinx
    sphinxcontrib-jquery
  ];

  pythonRelaxDeps = [
    "docutils"
    "sphinxcontrib-jquery"
    # https://github.com/readthedocs/sphinx_rtd_theme/pull/1666
    "sphinx"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # docutils 0.21 compat
    "test_basic"
  ];

  pythonImportsCheck = [ "sphinx_rtd_theme" ];

  meta = {
    description = "Sphinx theme for readthedocs.org";
    homepage = "https://github.com/readthedocs/sphinx_rtd_theme";
    changelog = "https://github.com/readthedocs/sphinx_rtd_theme/blob/${version}/docs/changelog.rst";
    license = lib.licenses.mit;
  };
}
