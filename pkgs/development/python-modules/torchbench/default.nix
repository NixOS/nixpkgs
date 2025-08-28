{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  numpy,
  opencv4,
  sotabenchapi,
  torch,
  torchvision,
  tqdm,
}:

let
  version = "0.0.31";
  pname = "torchbench";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EBZzcnRT50KREIOPrr/OZTJ4639ZUEejcelh3QSBcZ8=";
  };

  # requirements.txt is missing in the Pypi archive and this makes the setup.py script fails
  postPatch = ''
    touch requirements.txt
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    opencv4
    sotabenchapi
    torch
    torchvision
    tqdm
  ];

  pythonImportsCheck = [
    "torchbench"
  ];

  # No tests
  doCheck = false;

  meta = {
    description = "Easily benchmark machine learning models in PyTorch";
    homepage = "https://github.com/paperswithcode/torchbench";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
  };
}
