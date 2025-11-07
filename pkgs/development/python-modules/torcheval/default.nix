{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  typing-extensions,
}:
let
  pname = "torcheval";
  version = "0.0.7";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "meta-pytorch";
    repo = "torcheval";
    # Upstream has not created a tag for this version
    # https://github.com/pytorch/torcheval/issues/215
    rev = "f1bc22fc67ec2c77ee519aa4af8079f4fdaa41bb";
    hash = "sha256-aVr4qKKE+dpBcJEi1qZJBljFLUl8d7D306Dy8uOojJE=";
  };

  build-system = [ setuptools ];

  dependencies = [ typing-extensions ];

  pythonImportsCheck = [ "torcheval" ];

  # Tests are very flaky and computationally intensive
  doCheck = false;

  meta = {
    description = "Rich collection of performant PyTorch model metrics and tools for PyTorch model evaluations";
    homepage = "https://pytorch.org/torcheval";
    changelog = "https://github.com/meta-pytorch/torcheval/releases/tag/${version}";

    platforms = lib.platforms.unix;
    license = [ lib.licenses.bsd3 ];
    maintainers = [ lib.maintainers.bengsparks ];
  };
}
