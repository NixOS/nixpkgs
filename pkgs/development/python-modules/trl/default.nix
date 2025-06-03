{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  accelerate,
  datasets,
  rich,
  transformers,
}:

buildPythonPackage rec {
  pname = "trl";
  version = "0.17.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "trl";
    tag = "v${version}";
    hash = "sha256-kRZhtrKGNTJ9TJypRG9dABNn00w77dwx+JxT+2PUrfY=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    accelerate
    datasets
    rich
    transformers
  ];

  # Many tests require internet access.
  doCheck = false;

  pythonImportsCheck = [ "trl" ];

  meta = {
    description = "Train transformer language models with reinforcement learning";
    homepage = "https://github.com/huggingface/trl";
    changelog = "https://github.com/huggingface/trl/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hoh ];
  };
}
