{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cryptography,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "spake2";
  version = "0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "warner";
    repo = "python-spake2";
    tag = "v${version}";
    hash = "sha256-WPMGH1OzG+5O+2lNl2sv06/dNardY+BHYDS290Z36vQ=";
  };

  build-system = [ setuptools ];

  dependencies = [ cryptography ];

  pythonImportsCheck = [ "spake2" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    changelog = "https://github.com/warner/python-spake2/blob/v${version}/NEWS";
    description = "SPAKE2 password-authenticated key exchange library";
    homepage = "https://github.com/warner/python-spake2";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
