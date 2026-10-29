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
  version = "0.4.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "firefly-cpp";
    repo = "succulent";
    tag = version;
    hash = "sha256-UnsjmsOigScAW7qlbV3JCJljENrWvZd7gQRSCGSZn+8=";
  };

  pythonRelaxDeps = [
    "flask"
    "lxml"
    "numpy"
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
