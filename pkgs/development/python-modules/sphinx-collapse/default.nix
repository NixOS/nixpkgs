{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  sphinx,
}:

buildPythonPackage rec {
  pname = "sphinx-collapse";
  version = "0.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dgarcia360";
    repo = "sphinx-collapse";
    rev = version;
    hash = "sha256-ehKtXqq7FPrEKg5o8+61xLFMnD+5d7fHYXYeT+PkHWk=";
  };

  build-system = [ flit-core ];

  checkInputs = [ sphinx ];

  pythonImportsCheck = [ "sphinx_collapse" ];

  meta = {
    description = "Sphinx extension to hide large amounts of content";
    homepage = "https://github.com/dgarcia360/sphinx-collapse";
    changelog = "https://github.com/dgarcia360/sphinx-collapse/blob/${src.rev}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nim65s ];
  };
}
