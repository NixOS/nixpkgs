{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pyyaml,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "yamlcore";
  version = "0.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "perlpunk";
    repo = "pyyaml-core";
    rev = "v${version}";
    hash = "sha256-TBVNmuhBfEo9HmDkalnn6VDVHF+sh/MIZ8f46Zdyxw8=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    pyyaml
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  enabledTestPaths = [ "tests/*.py" ];

  # This ensures the module can be imported after building
  pythonImportsCheck = [ "yamlcore" ];

  meta = {
    description = "YAML 1.2 Support for PyYAML";
    homepage = "https://github.com/perlpunk/pyyaml-core";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gonsolo ];
  };
}
