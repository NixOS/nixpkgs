{ lib
, fetchPypi
, buildPythonPackage
, python
, zope_testrunner
, transaction
, six
, zope_interface
, zodbpickle
, zconfig
, persistent
, zc_lockfile
, BTrees
, manuel
}:

buildPythonPackage rec {
  pname = "ZODB";
  version = "5.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-KNugDvYm3hBYnt7auFrQ8O33KSXnXTahXJnGOsBf52Q=";
  };

  # remove broken test
  postPatch = ''
    rm -vf src/ZODB/tests/testdocumentation.py
  '';

  propagatedBuildInputs = [
    transaction
    six
    zope_interface
    zodbpickle
    zconfig
    persistent
    zc_lockfile
    BTrees
  ];

  nativeCheckInputs = [
    manuel
    zope_testrunner
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
