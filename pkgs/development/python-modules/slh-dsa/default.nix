{
  lib,
  buildPythonPackage,
  fetchPypi,
  pdm-backend,
}:

buildPythonPackage rec {
  pname = "slh-dsa";
  version = "0.2.0";
  pyproject = true;

  src = fetchPypi {
    pname = "slh_dsa";
    inherit version;
    hash = "sha256-p4eWMVayOFiEjFtlnsmmtH6HMfcIeYIpgdfjuB4mmAY=";
  };

  build-system = [ pdm-backend ];

  pythonImportsCheck = [ "slhdsa" ];

  meta = {
    description = "Pure Python implementation of the SLH-DSA algorithm";
    homepage = "https://github.com/colinxu2020/slhdsa";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ prusnak ];
  };
}
