{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  python,
  pythonAtLeast,

  # build-system
  setuptools,

  # dependencies
  btrees,
  persistent,
  transaction,
  zc-lockfile,
  zconfig,
  zodbpickle,
  zope-interface,

  # tests
  manuel,
  zope-testing,
  zope-testrunner,
}:

buildPythonPackage (finalAttrs: {
  pname = "zodb";
  version = "6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zodb";
    tag = finalAttrs.version;
    hash = "sha256-XeLCzX6qBBAO2HgEtc2+/2z6DRn0UQjI036y+DbcKmQ=";
  };

  postPatch = ''
    # remove broken test
    rm -vf src/ZODB/tests/testdocumentation.py
  ''
  + lib.optionalString (pythonAtLeast "3.14") ''
    # remove broken under python 3.14
    rm -vf src/ZODB/tests/testConnectionSavepoint.py
    rm -vf src/ZODB/tests/testMVCCMappingStorage.py
    rm -vf src/ZODB/tests/testFileStorage.py
    rm -vf src/ZODB/tests/testblob.py
  '';

  build-system = [ setuptools ];

  dependencies = [
    btrees
    persistent
    transaction
    zc-lockfile
    zconfig
    zodbpickle
    zope-interface
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
    changelog = "https://github.com/zopefoundation/ZODB/blob/${finalAttrs.src.tag}/CHANGES.rst";
    downloadPage = "https://github.com/zopefoundation/ZODB";
    license = lib.licenses.zpl21;
    maintainers = [ ];
  };
})
