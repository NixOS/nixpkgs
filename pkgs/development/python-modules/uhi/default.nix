{
  lib,
  fetchPypi,
  boost-histogram,
  buildPythonPackage,
  h5py,
  hatchling,
  hatch-vcs,
  hist,
  fastjsonschema,
  numpy,
  packaging,
  pytestCheckHook,
  pythonOlder,
  tomli,
  typing-extensions,
  uhi,
}:

buildPythonPackage rec {
  pname = "uhi";
  version = "1.2.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/G7lskV69UTYmATvX1Uwyl/JSKUuMWjNXEU5sDp0Lc4=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    numpy
  ]
  ++ lib.optionals (pythonOlder "3.11") [
    typing-extensions
  ];

  optional-dependencies = {
    schema = [ fastjsonschema ];
    hdf5 = [ h5py ];
  };

  doCheck = false; # Prevents infinite recursion; use passthru.tests instead

  nativeCheckInputs = [
    boost-histogram
    hist
    fastjsonschema
    packaging
    pytestCheckHook
  ]
  ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  passthru.tests.uhi = uhi.overridePythonAttrs { doCheck = true; };

  meta = {
    description = "Universal Histogram Interface";
    homepage = "https://uhi.readthedocs.io/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
