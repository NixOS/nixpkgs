{ stdenv
, fetchPypi
, buildPythonPackage
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
    version = "5.5.1";

    src = fetchPypi {
      inherit pname version;
      sha256 = "20155942fa326e89ad8544225bafd74237af332ce9d7c7105a22318fe8269666";
    };

    patches = [
      ./ZODB-5.3.0-fix-tests.patch # still needeed with 5.4.0
      # Upstream patch to fix tests with persistent 4.4,
      # cannot fetchpatch because only one hunk of the upstream commit applies.
      # TODO remove on next release
      ./fix-tests-with-persistent-4.4.patch
    ];

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

    meta = with stdenv.lib; {
      description = "Zope Object Database: object database and persistence";
      homepage = https://pypi.python.org/pypi/ZODB;
      license = licenses.zpl21;
      maintainers = with maintainers; [ goibhniu ];
    };
}
