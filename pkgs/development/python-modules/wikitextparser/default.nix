{
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  lib,
  setuptools,
  pytestCheckHook,
  regex,
  wcwidth,
}:

buildPythonPackage rec {
  pname = "wikitextparser";
  version = "0.56.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "5j9";
    repo = "wikitextparser";
    rev = "v${version}";
    hash = "sha256-g0Hvxw8evmCebM2joGT7XMnakVjDG74VJmZhlvUiQMU=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    flit-core
    wcwidth
    regex
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "wikitextparser" ];

  meta = {
    homepage = "https://github.com/5j9/wikitextparser";
    description = "Simple parsing tool for MediaWiki's wikitext markup";
    changelog = "https://github.com/5j9/wikitextparser/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ rapiteanu ];
  };
}
