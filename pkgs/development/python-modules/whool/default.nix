{
  buildPythonPackage,
  fetchFromGitHub,
  git,
  hatch-vcs,
  lib,
  manifestoo-core,
  pytestCheckHook,
  pythonOlder,
  tomli,
  wheel,
}:

buildPythonPackage rec {
  pname = "whool";
  version = "1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sbidoul";
    repo = "whool";
    tag = "v${version}";
    hash = "sha256-vY7MPTBjNy3LY29k0MjMDnPiU7l9lUvPvTCrji8A5Cw=";
  };

  build-system = [ hatch-vcs ];

  dependencies = [
    manifestoo-core
    wheel
  ]
  ++ lib.optionals (pythonOlder "3.11") [ tomli ];

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
