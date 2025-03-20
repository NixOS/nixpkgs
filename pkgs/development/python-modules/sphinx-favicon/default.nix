{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  sphinx,
  pytestCheckHook,
  beautifulsoup4,
}:

buildPythonPackage rec {
  pname = "sphinx-favicon";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tcmetzger";
    repo = "sphinx-favicon";
    tag = "v${version}";
    hash = "sha256-Arcjj+6WWuSfufh8oqrDyAtjp07j1JEuw2YlmFcfL3U=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    sphinx
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  checkInputs = [
    beautifulsoup4
  ];

  disabledTests = [
    # requires network to download favicons
    "test_list_of_three_icons_automated_values"
  ];

  pythonImportsCheck = [ "sphinx_favicon" ];

  meta = {
    description = "Sphinx extension to add custom favicons";
    homepage = "https://github.com/tcmetzger/sphinx-favicon";
    changelog = "https://github.com/tcmetzger/sphinx-favicon/blob/v${version}/CHANGELOG";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.newam ];
  };
}
