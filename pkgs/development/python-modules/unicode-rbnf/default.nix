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
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "unicode-rbnf";
    rev = "refs/tags/v${version}";
    hash = "sha256-dAoDO707qmdDzCbi7EWNaM9txdBV46NlLkOs7xyycz0=";
  };

  nativeBuildInputs = [ setuptools ];

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
