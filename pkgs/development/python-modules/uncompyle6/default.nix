{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  setuptools,
  spark-parser,
  xdis,
  pytestCheckHook,
  hypothesis,
  six,
}:

buildPythonPackage rec {
  pname = "uncompyle6";
  version = "3.9.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eLdk1MhDsEVfs5223rQhpI1dPruEZTe6ZESv4QfE68E=";
  };

  patches = [
    (fetchpatch {
      name = "support-xdis-6.3-api.patch";
      url = "https://github.com/rocky/python-uncompyle6/commit/62372825c62044428c29a9ce86b5afa81e93c5ae.patch";
      hash = "sha256-z11AKF5RC4gibUbH3hI2Rsbn8VDg49SnKfqV4TuVnjc=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    spark-parser
    xdis
  ];

  pythonRelaxDeps = [ "spark-parser" ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
    six
  ];

  # No tests are provided for versions past 3.8,
  # as the project only targets bytecode of versions <= 3.8
  doCheck = false;

  meta = {
    description = "Bytecode decompiler for Python versions 3.8 and below";
    homepage = "https://github.com/rocky/python-uncompyle6";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ melvyn2 ];
  };
}
