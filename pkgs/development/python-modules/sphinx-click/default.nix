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
<<<<<<< HEAD
  version = "6.2.0";
=======
  version = "6.1.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    hash = "sha256-/Hi0FUpOUVlGLjbeVbhkN0fabNqGs7Uqi7YiieYDd2w=";
=======
    hash = "sha256-xwLgdRwaC2rWSeT3+uvQ3AmjzHyjtQ+Vlpg4N3L1Du8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  meta = {
    description = "Sphinx extension that automatically documents click applications";
    homepage = "https://github.com/click-contrib/sphinx-click";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ antonmosich ];
  };
}
