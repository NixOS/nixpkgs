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
  version = "1.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MxGIlJsaScjbnvnVC3xNTfRgYRXRR97ZfE8FDagnDnQ=";
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

  meta = {
    description = "Universal Histogram Interface";
    homepage = "https://uhi.readthedocs.io/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
