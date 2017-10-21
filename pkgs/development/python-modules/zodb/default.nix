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
    version = "5.2.4";
    name = "${pname}-${version}";

    src = fetchPypi {
      inherit pname version;
      sha256 = "1pya0inkkxaqmi14gp796cidf894nz64n603zk670jj9xz0wkhgc";
    };

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
      homepage = http://pypi.python.org/pypi/ZODB;
      license = licenses.zpl21;
      maintainers = with maintainers; [ goibhniu ];
    };
}
