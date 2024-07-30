{
  lib,
  buildPythonPackage,
  fetchPypi,
  aiohttp,
}:

buildPythonPackage rec {
  pname = "smarthab";
  version = "0.21";
  format = "setuptools";

  src = fetchPypi {
    pname = "SmartHab";
    inherit version;
    sha256 = "bf929455a2f7cc1e275b331de73d983587138a8d9179574988ba05fa152d3ccf";
  };

  propagatedBuildInputs = [ aiohttp ];

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
