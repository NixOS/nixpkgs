{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  huggingface-hub,
  numpy,
  safetensors,
  tqdm,
}:

buildPythonPackage rec {
  pname = "staticvectors";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "neuml";
    repo = "staticvectors";
    tag = "v${version}";
    hash = "sha256-p3m22qLxQYma0WtkTE/GzHXkxNHjatqLOdeHh4vtyVc=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    huggingface-hub
    numpy
    safetensors
    tqdm
  ];

  pythonImportsCheck = [ "staticvectors" ];

  # no tests
  doCheck = false;

  meta = {
    description = "Work with static vector models";
    homepage = "https://github.com/neuml/staticvectors";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
