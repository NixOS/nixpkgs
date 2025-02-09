{
  lib,
  fetchPypi,
  buildPythonPackage,
  hatchling,
  hatch-vcs,
  fastjsonschema,
  numpy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "uhi";
  version = "0.5.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lVm78vOPGKL8HY9zE5OWBo+I+JjWqa/IMyB+wP1Zoxw=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    fastjsonschema
    numpy
  ];

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Universal Histogram Interface";
    homepage = "https://uhi.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ veprbl ];
  };
}
