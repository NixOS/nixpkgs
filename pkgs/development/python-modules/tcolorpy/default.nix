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
  version = "0.1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-esucU+So1YKzkuMt6ICCrQ5SzQVv24lh12SE1Jl5Y/w=";
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
