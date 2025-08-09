{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "unicode-rbnf";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "unicode-rbnf";
    tag = "v${version}";
    hash = "sha256-RRPQHU8UMVspbhqKVR165czbYY42JopF6Nrhm0up3hw=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "unicode_rbnf" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    changelog = "https://github.com/rhasspy/unicode-rbnf/blob/v${version}/CHANGELOG.md";
    description = "Pure Python implementation of ICU's rule-based number format engine";
    homepage = "https://github.com/rhasspy/unicode-rbnf";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
