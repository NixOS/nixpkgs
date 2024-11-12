{
  lib,
  buildPythonPackage,
  fetchPypi,
  aiohttp,
  setuptools,
}:

buildPythonPackage rec {
  pname = "smarthab";
  version = "0.21";
  pyproject = true;

  src = fetchPypi {
    pname = "SmartHab";
    inherit version;
    hash = "sha256-v5KUVaL3zB4nWzMd5z2YNYcTio2ReVdJiLoF+hUtPM8=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # no tests on PyPI, no tags on GitLab
  doCheck = false;

  pythonImportsCheck = [ "pysmarthab" ];

  meta = with lib; {
    description = "Control devices in a SmartHab-powered home";
    homepage = "https://gitlab.com/outadoc/python-smarthab";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
