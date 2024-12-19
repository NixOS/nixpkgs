{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  spark-parser,
  xdis,
  pytestCheckHook,
  hypothesis,
  six,
}:

buildPythonPackage rec {
  pname = "uncompyle6";
  version = "3.9.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-b3CYD/4IpksRS2hxgy/QLYbJkDX4l2qPH4Eh2tb8pCU=";
  };

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
    description = "A bytecode decompiler for Python versions 3.8 and below";
    homepage = "https://github.com/rocky/python-uncompyle6";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ melvyn2 ];
  };
}
