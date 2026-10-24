{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  sphinx,
}:

buildPythonPackage rec {
  pname = "sphinx-bootstrap-theme";
  version = "0.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ryan-roemer";
    repo = "sphinx-bootstrap-theme";
    tag = "v${version}";
    hash = "sha256-T9quULA7cY+DtV74x3F7rIFxkljVndoSYC+nGF9m3Vk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    sphinx
  ];

  pythonImportsCheck = [ "sphinx_bootstrap_theme" ];

  meta = {
    homepage = "https://github.com/ryan-roemer/sphinx-bootstrap-theme";
    description = "Sphinx theme that integrates the Bootstrap CSS / JavaScript framework";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ kaction ];
  };
}
