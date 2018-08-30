{ stdenv
, fetchPypi
, buildPythonPackage
, zope_testrunner
, transaction
, six
, wheel
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
    version = "5.4.0";

    src = fetchPypi {
      inherit pname version;
      sha256 = "0b306042f4f0d558a477d65c34b0dd6e7604c6e583f55dfda52befa2fa13e076";
    };

    patches = [
      ./ZODB-5.3.0-fix-tests.patch
    ];

    propagatedBuildInputs = [
      manuel
      transaction
      zope_testrunner
      six
      wheel
      zope_interface
      zodbpickle
      zconfig
      persistent
      zc_lockfile
      BTrees
    ];

    meta = with stdenv.lib; {
      description = "Zope Object Database: object database and persistence";
      homepage = https://pypi.python.org/pypi/ZODB;
      license = licenses.zpl21;
      maintainers = with maintainers; [ goibhniu ];
    };
}
