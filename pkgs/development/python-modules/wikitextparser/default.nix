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

buildPythonPackage (finalAttrs: {
  pname = "wikitextparser";
  version = "0.56.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "5j9";
    repo = "wikitextparser";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xg2cWhfJXS7zUuzXPslFTZz6mY/Pvl2F2b7HNWV2c3I=";
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
    changelog = "https://github.com/5j9/wikitextparser/blob/v${finalAttrs.version}/CHANGELOG.rst";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ rapiteanu ];
  };
})
