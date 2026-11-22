{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flask,
  lxml,
  numpy,
  pandas,
  pyyaml,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "succulent";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "firefly-cpp";
    repo = "succulent";
    tag = version;
    hash = "sha256-gA+hIwHMdrCl48gAxXc5T8BaLciaUB6Z0uL+nRMTubc=";
  };

  pythonRelaxDeps = [
    "pandas"
  ];

  build-system = [
    poetry-core
  ];

  dependencies = [
    flask
    lxml
    numpy
    pandas
    pyyaml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "succulent" ];

  meta = {
    description = "Collect POST requests";
    homepage = "https://github.com/firefly-cpp/succulent";
    changelog = "https://github.com/firefly-cpp/succulent/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ firefly-cpp ];
  };
}
