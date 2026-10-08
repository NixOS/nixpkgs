{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  mypy,
  pytestCheckHook,
  pytest-xdist,
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

  env.SLHDSA_BUILD_OPTIMIZED = "1";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"mypy>=1.10.1",' ""
  '';

  build-system = [
    setuptools
    mypy
  ];

  pythonImportsCheck = [ "slhdsa" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
  ];

  meta = {
    description = "Pure Python implementation of the SLH-DSA algorithm";
    homepage = "https://github.com/colinxu2020/slhdsa";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ prusnak ];
  };
}
