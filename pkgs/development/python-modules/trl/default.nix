{
  lib,
  buildPythonPackage,
  pkgs,
  fetchFromGitHub,
  python3Packages,
  setuptools,
  setuptools-scm,
  accelerate,
  datasets,
  rich,
  transformers,
}:

buildPythonPackage rec {
  pname = "trl";
  version = "0.15.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "trl";
    tag = "v${version}";
    sha256 = "sha256-HsSmFXFqDOWVLa6VXdPZVS9C3bjYcsliR0TwNpPiQx4=";
  };

  build-system = [ setuptools ];
  nativeBuildInputs = [ setuptools-scm ];

  dependencies = [
    accelerate
    datasets
    rich
    transformers
  ];

  doCheck = true;

  pythonImportsCheck = [ "trl" ];

  meta = {
    description = "Train transformer language models with reinforcement learning";
    homepage = "https://github.com/huggingface/trl";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hoh ];
  };
}
