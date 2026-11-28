{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  accelerate,
  datasets,
  packaging,
  rich,
  transformers,
}:

buildPythonPackage (finalAttrs: {
  pname = "trl";
  version = "1.18.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "trl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VRABwKwCyy4C7NrkpYu5qPlz5aRmSc/wGq3AFtO6w34=";
  };

  build-system = [ setuptools ];

  dependencies = [
    accelerate
    datasets
    packaging
    rich
    transformers
  ];

  # Many tests require internet access.
  doCheck = false;

  pythonImportsCheck = [ "trl" ];

  meta = {
    description = "Train transformer language models with reinforcement learning";
    homepage = "https://github.com/huggingface/trl";
    changelog = "https://github.com/huggingface/trl/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hoh ];
  };
})
