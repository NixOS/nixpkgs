{ lib
, fetchPypi
, buildPythonPackage
, python
, zope-testrunner
, transaction
, six
, zope-interface
, zodbpickle
, zconfig
, persistent
, zc-lockfile
, btrees
, manuel
}:

buildPythonPackage rec {
  pname = "ZODB";
  version = "5.8.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xsc6vTZg1gb/wfIfl97xS1K0b0pwLsnm7kSabiviZN8=";
  };

  # remove broken test
  postPatch = ''
    rm -vf src/ZODB/tests/testdocumentation.py
  '';

  propagatedBuildInputs = [
    transaction
    six
    zope-interface
    zodbpickle
    zconfig
    persistent
    zc-lockfile
    btrees
  ];

  nativeCheckInputs = [
    manuel
    zope-testrunner
  ];

  checkPhase = ''
    ${python.interpreter} -m zope.testrunner --test-path=src []
  '';

  meta = with lib; {
    description = "Zope Object Database: object database and persistence";
    homepage = "https://zodb-docs.readthedocs.io/";
    changelog = "https://github.com/zopefoundation/ZODB/blob/${version}/CHANGES.rst";
    license = licenses.zpl21;
    maintainers = with maintainers; [ goibhniu ];
  };
}
