{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "tcolorpy";
  version = "0.1.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = "tcolorpy";
    tag = "v${version}";
    hash = "sha256-0AXpwRQgBisO4360J+Xd4+EWzDtDJ64UpSUmDnSYjKE=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonImportsCheck = [ "tcolorpy" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage = "https://github.com/thombashi/tcolorpy";
    description = "Library to apply true color for terminal text";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.mit;
  };
}
