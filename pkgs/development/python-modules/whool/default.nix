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
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sbidoul";
    repo = "whool";
    rev = "refs/tags/v${version}";
    hash = "sha256-skJoMDIgZgRjfp4tsc6TKYVe09XBvg8Fk2BQfqneCYI=";
  };

  build-system = [ hatch-vcs ];

  dependencies = [
    manifestoo-core
    wheel
  ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  pythonImportsCheck = [ "whool" ];

  nativeCheckInputs = [
    pytestCheckHook
    git
  ];

  setupHook = ./setup-hook.sh;

  meta = {
    description = "Standards-compliant Python build backend to package Odoo addons";
    homepage = "https://github.com/sbidoul/whool";
    changelog = "https://github.com/sbidoul/whool/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.yajo ];
  };
}
