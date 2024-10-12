{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  spark-parser,
  xdis,
  nose,
  pytestCheckHook,
  hypothesis,
  six,
}:

buildPythonPackage rec {
  pname = "uncompyle6";
  version = "3.9.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-b3CYD/4IpksRS2hxgy/QLYbJkDX4l2qPH4Eh2tb8pCU=";
  };

  propagatedBuildInputs = [
    spark-parser
    xdis
  ];

  nativeCheckInputs = [
    nose
    pytestCheckHook
    hypothesis
    six
  ];

  # No tests are provided for versions past 3.8,
  # as the project only targets bytecode of versions <= 3.8
  doCheck = pythonOlder "3.9";

  meta = {
    description = "A bytecode decompiler for Python versions 3.8 and below";
    homepage = "https://github.com/rocky/python-uncompyle6";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ melvyn2 ];
  };
}
