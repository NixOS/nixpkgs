{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # build-system
  hatchling,
  hatch-fancy-pypi-readme,
  # dependencies
  lxml,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "yaxmldiff";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "latk";
    repo = "yaxmldiff.py";
    tag = "v${version}";
    hash = "sha256-AOXnK1d+b/ae50ofBfgxiDS6Dj6TIeHMrE9ME95Yj1Q=";
  };

  build-system = [
    hatchling
    hatch-fancy-pypi-readme
  ];

  dependencies = [ lxml ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Yet Another XML Differ";
    homepage = "https://github.com/latk/yaxmldiff.py";
    changelog = "https://https://github.com/latk/yaxmldiff.py/blob/v${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
