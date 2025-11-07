{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  python,
  setuptools,
  zope-testing,
  zope-testrunner,
  transaction,
  zope-interface,
  zodbpickle,
  zconfig,
  persistent,
  zc-lockfile,
  btrees,
  manuel,
}:

buildPythonPackage rec {
  pname = "zodb";
  version = "6.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zodb";
    tag = version;
    hash = "sha256-2OK1ezHFEpOMOrpB8Nzf/6+4AlV3S7p11dQHkeMqhoo=";
  };

  # remove broken test
  postPatch = ''
    rm -vf src/ZODB/tests/testdocumentation.py
  '';

  build-system = [ setuptools ];

  dependencies = [
    transaction
    zope-interface
    zodbpickle
    zconfig
    persistent
    zc-lockfile
    btrees
  ];

  nativeCheckInputs = [
    manuel
    zope-testing
    zope-testrunner
  ];

  checkPhase = ''
    ${python.interpreter} -m zope.testrunner --test-path=src []
  '';

  meta = {
    description = "Zope Object Database: object database and persistence";
    homepage = "https://zodb-docs.readthedocs.io/";
    changelog = "https://github.com/zopefoundation/ZODB/blob/${version}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = [ ];
  };
}
