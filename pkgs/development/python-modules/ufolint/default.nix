{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  commandlines,
  fonttools,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "ufolint";
  version = "1.2.0";
  pyproject = true;

  # PyPI source tarballs omit tests, fetch from Github instead
  src = fetchFromGitHub {
    owner = "source-foundry";
    repo = "ufolint";
    rev = "v${finalAttrs.version}";
    hash = "sha256-sv8WbnDd2LFHkwNsB9FO04OlLhemdzwjq0tC9+Fd6/M=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [
    commandlines
    fonttools
  ]
  ++ fonttools.optional-dependencies.ufo;

  nativeBuildInputs = [ pytestCheckHook ];

  meta = {
    description = "Linter for Unified Font Object (UFO) source code";
    mainProgram = "ufolint";
    homepage = "https://github.com/source-foundry/ufolint";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ danc86 ];
  };
})
