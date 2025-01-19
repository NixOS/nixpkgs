{
  lib,
  buildPythonPackage,
  fetchPypi,
  nose2,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "setuptools-dso";
  version = "2.11";
  pyproject = true;

  src = fetchPypi {
    pname = "setuptools_dso";
    inherit version;
    hash = "sha256-lT5mp0TiHbvkrXPiK5/uLke65znya8Y6s3RzpFuXVFY=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    nose2
    pytestCheckHook
  ];

  meta = {
    description = "setuptools extension for building non-Python Dynamic Shared Objects";
    homepage = "https://github.com/mdavidsaver/setuptools_dso";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ marius851000 ];
  };
}
