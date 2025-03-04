{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  zope-interface,
}:

buildPythonPackage rec {
  pname = "zope-exceptions";
  version = "5.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.exceptions";
    tag = version;
    hash = "sha256-jbzUUB6ifTfxiGEiyAmsDoDLyRVuZPgIsN8mCNJkv4Q=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    setuptools
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
