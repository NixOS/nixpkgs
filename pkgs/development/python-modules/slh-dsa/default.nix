{
  lib,
  buildPythonPackage,
  fetchPypi,
  pdm-backend,
}:

buildPythonPackage rec {
  pname = "slh-dsa";
  version = "0.1.3";
  pyproject = true;

  src = fetchPypi {
    pname = "slh_dsa";
    inherit version;
    hash = "sha256-0OtjlI/w3F0OWu+fsQI9M3lIQY0Nx48YbvoGcQ0AJ1Y=";
  };

  build-system = [ pdm-backend ];

  pythonImportsCheck = [ "slhdsa" ];

  meta = with lib; {
    description = "Pure Python implementation of the SLH-DSA algorithm";
    homepage = "https://github.com/colinxu2020/slhdsa";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };
}
