{
  lib,
  fetchPypi,
  buildPythonPackage,
  hatchling,
  hatch-vcs,
  numpy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "uhi";
  version = "0.4.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DctrGXdQh9OKMe44jLLHDy7P4ExP/iymMiNBDK5b7vo=";
  };

  buildInputs = [
    hatchling
    hatch-vcs
  ];

  propagatedBuildInputs = [ numpy ];

  checkInputs = [ pytestCheckHook ];

  meta = {
    description = "Universal Histogram Interface";
    homepage = "https://uhi.readthedocs.io/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
