{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  torch,
}:

buildPythonPackage rec {
  pname = "torchsummary";
  version = "1.5.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mBv2ieIuDPf5XHRgAvIKJK0mqmudhhE0oUvGzpIjBZA=";
  };

  build-system = [ setuptools ];

  dependencies = [ torch ];

  # no tests in pypi tarball
  doCheck = false;

  pythonImportsCheck = [ "torchsummary" ];

  meta = {
    description = "Model summary in PyTorch similar to `model.summary()` in Keras";
    homepage = "https://github.com/sksq96/pytorch-summary";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
