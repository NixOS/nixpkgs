{ stdenv
, fetchPypi
, buildPythonPackage
, isPy3k
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
    version = "5.3.0";
    name = "${pname}-${version}";

    src = fetchPypi {
      inherit pname version;
      sha256 = "633c2f89481d8ebc55639b59216f7d16d07b44a94758850c0b887006967214f3";
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
