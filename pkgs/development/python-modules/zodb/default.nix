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
  version = "6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zodb";
    tag = version;
    hash = "sha256-O6mu4RWi5qNcPyIgre5+bk4ZGZOZdG1vIdc8HqbfcaQ=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools ==" "setuptools >="

    # remove broken test
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
