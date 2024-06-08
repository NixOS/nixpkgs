{
  lib,
  fetchPypi,
  buildPythonPackage,
  python,
  zope-testrunner,
  transaction,
  six,
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
  version = "6.0";

  src = fetchPypi {
    pname = "ZODB";
    inherit version;
    hash = "sha256-5Rx5IRXF2q1OgGdXuvovdUwADCPmurw75eQHdf5Jtdw=";
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
