{
  buildPythonPackage,
  fetchFromGitHub,
  git,
  hatch-vcs,
  lib,
  manifestoo-core,
  pytestCheckHook,
  wheel,
}:

buildPythonPackage rec {
  pname = "whool";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sbidoul";
    repo = "whool";
    tag = "v${version}";
    hash = "sha256-mzkU8P+NAyDsVFfcAvWQi+ZYCiM34ZCO6H+qz4SZGfg=";
  };

  build-system = [ hatch-vcs ];

  dependencies = [
    manifestoo-core
    wheel
  ];

  pythonImportsCheck = [ "whool" ];

  nativeCheckInputs = [
    pytestCheckHook
    git
  ];

  setupHook = ./setup-hook.sh;

  meta = {
    description = "Standards-compliant Python build backend to package Odoo addons";
    homepage = "https://github.com/sbidoul/whool";
    changelog = "https://github.com/sbidoul/whool/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.yajo ];
  };
}
