{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  commandlines,
  fonttools,
  fs,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ufolint";
  version = "1.2.0";
  format = "setuptools";

  # PyPI source tarballs omit tests, fetch from Github instead
  src = fetchFromGitHub {
    owner = "source-foundry";
    repo = "ufolint";
    rev = "v${version}";
    hash = "sha256-sv8WbnDd2LFHkwNsB9FO04OlLhemdzwjq0tC9+Fd6/M=";
  };

  propagatedBuildInputs = [
    commandlines
    fs
    fonttools
  ];

  doCheck = true;
  nativeBuildInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Linter for Unified Font Object (UFO) source code";
    mainProgram = "ufolint";
    homepage = "https://github.com/source-foundry/ufolint";
    license = licenses.mit;
    maintainers = with maintainers; [ danc86 ];
  };
}
