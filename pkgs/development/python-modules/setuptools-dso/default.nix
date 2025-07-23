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
  version = "2.12.2";
  pyproject = true;

  src = fetchPypi {
    pname = "setuptools_dso";
    inherit version;
    hash = "sha256-evt2+T0Tzp2iRQJnbY8tTbw9o1xiRflfJ9+fp0RQeaQ=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    nose2
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Setuptools extension for building non-Python Dynamic Shared Objects";
    homepage = "https://github.com/mdavidsaver/setuptools_dso";
    license = licenses.bsd3;
    maintainers = with maintainers; [ marius851000 ];
  };
}
