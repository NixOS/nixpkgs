{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  fsspec,
  numpy,
  packaging,
  psutil,
  pyre-extensions,
  tabulate,
  tensorboard,
  torch,
  tqdm,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "torchtnt";
  version = "0.2.4";
  pyproject = true;

  # no tag / releases on github
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Js9OcYllr8KT52FYtHKDciBVvPeelNDmfnC12/YcDJs=";
  };

  # requirements.txt is not included in Pypi archive
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'read_requirements("requirements.txt")' "[]" \
      --replace-fail 'read_requirements("dev-requirements.txt")' "[]"
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    fsspec
    numpy
    packaging
    psutil
    pyre-extensions
    setuptools
    tabulate
    tensorboard
    torch
    tqdm
    typing-extensions
  ];

  pythonImportsCheck = [
    "torchtnt"
  ];

  # Tests are not included in Pypi archive
  doCheck = false;

  meta = with lib; {
    description = "Lightweight library for PyTorch training tools and utilities";
    homepage = "https://github.com/pytorch/tnt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nim65s ];
  };
}
