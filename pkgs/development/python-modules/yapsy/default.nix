{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "yapsy";
  version = "1.12.2-unstable-2023-03-29";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tibonihoo";
    repo = "yapsy";
    rev = "6b487b04affb19ab40adbbc87827668bea0abcee";
    hash = "sha256-QKZlUAhYMCCsT/jbEHb39ESZ2+2FZYnhJnc1PgsozBA=";
  };

  sourceRoot = "source/package";

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "yapsy" ];

  meta = with lib; {
    homepage = "https://yapsy.sourceforge.net/";
    description = "Yet another plugin system";
    license = licenses.bsd2;
  };
}
