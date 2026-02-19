{
  lib,
  buildPythonPackage,
  fetchPypi,
  sphinxHook,
  # Build system
  setuptools,
  setuptools-scm,
  # Dependencies
  click,
  docutils,
  sphinx,
  # Checks
  pytestCheckHook,
  defusedxml,
}:

buildPythonPackage rec {
  pname = "sphinx-click";
  version = "6.2.0";
  pyproject = true;

  build-system = [
    setuptools
    setuptools-scm
  ];

  postPatch = ''
    # Would require reno which would require the .git directory to stay around
    substituteInPlace docs/changelog.rst \
      --replace-fail '.. release-notes::' 'Check https://sphinx-click.readthedocs.io/en/latest/changelog/ for the Release Notes.'
    substituteInPlace docs/conf.py \
      --replace-fail "'reno.sphinxext'" ""
  '';

  nativeBuildInputs = [
    sphinxHook
  ];

  dependencies = [
    click
    docutils
    sphinx
  ];

  nativeCheckInputs = [
    pytestCheckHook
    defusedxml
  ];

  pythonImportsCheck = [
    "sphinx_click"
  ];

  src = fetchPypi {
    inherit version;
    pname = "sphinx_click";
    hash = "sha256-/Hi0FUpOUVlGLjbeVbhkN0fabNqGs7Uqi7YiieYDd2w=";
  };

  meta = {
    description = "Sphinx extension that automatically documents click applications";
    homepage = "https://github.com/click-contrib/sphinx-click";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ antonmosich ];
  };
}
