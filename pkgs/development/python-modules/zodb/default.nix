{ stdenv
, fetchPypi
, fetchpatch
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
    version = "5.5.1";

    src = fetchPypi {
      inherit pname version;
      sha256 = "20155942fa326e89ad8544225bafd74237af332ce9d7c7105a22318fe8269666";
    };

    patches = [
      # Compatibility with transaction v3.0
      (fetchpatch {
        url = "https://github.com/zopefoundation/ZODB/commit/0adcc6877f690186c97cc5da7e13788946d5e0df.patch";
        sha256 = "1zmbgm7r36nj5w7icpinp61fm81svh2wk213pzr3l0jxzr9i5qi4";
      })
    ];

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

    meta = with stdenv.lib; {
      description = "Zope Object Database: object database and persistence";
      homepage = https://pypi.python.org/pypi/ZODB;
      license = licenses.zpl21;
      maintainers = with maintainers; [ goibhniu ];
    };
}
