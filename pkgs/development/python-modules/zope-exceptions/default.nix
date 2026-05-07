{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  zope-interface,
}:

buildPythonPackage rec {
  pname = "zope-exceptions";
  version = "6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.exceptions";
    tag = version;
    hash = "sha256-LLKS/O1sfrHRfEgbb3GO+/hBtIC9CvfNjorqiKTgujo=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools ==" "setuptools >="
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    zope-interface
  ];

  # circular deps
  doCheck = false;

  pythonImportsCheck = [ "zope.exceptions" ];

  meta = {
    description = "Exception interfaces and implementations";
    homepage = "https://pypi.python.org/pypi/zope.exceptions";
    changelog = "https://github.com/zopefoundation/zope.exceptions/blob/${version}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
