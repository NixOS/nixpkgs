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
  version = "5.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zh7rd182l15swkbkm3ib0wgyn16xasdz2mzry8k4lwk6dagnm26";
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

  checkInputs = [
    manuel
    zope_testrunner
  ];

  checkPhase = ''
    ${python.interpreter} -m zope.testrunner --test-path=src []
  '';

  meta = with lib; {
    description = "Zope Object Database: object database and persistence";
    homepage = "https://pypi.python.org/pypi/ZODB";
    license = licenses.zpl21;
    maintainers = with maintainers; [ goibhniu ];
  };
}
