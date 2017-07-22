{ pythonPackages, fetchurl, stdenv }:

rec {
  zodb = pythonPackages.buildPythonPackage {
    name = "ZODB-5.2.0";
    src = fetchurl {
      url = "https://pypi.python.org/packages/1e/47/2f17075ca94a4a537ebd8e195c458456ef49aa67355ec805e478b8ad1959/ZODB-5.2.0.tar.gz";
      sha256 = "11l495lyym2fpvalj18yvcqwnsp8gyp18sgv5v575k4s2035lz0x";
    };
    doCheck = false;
    propagatedBuildInputs = [
      transaction
    ] ++ (with pythonPackages; [
      six
      wheel
      zope_interface
      zodbpickle
      zconfig
      persistent
      zc_lockfile
      BTrees
    ]);

    meta = with stdenv.lib; {
      homepage = "";
      license = licenses.zpt21;
      description = "Zope Object Database: object database and persistence";
    };
  };

  transaction = pythonPackages.buildPythonPackage {
    name = "transaction-2.0.3";
    src = fetchurl {
      url = "https://pypi.python.org/packages/8c/af/3ffafe85bcc93ecb09459f3f2bd8fbe142e9ab34048f9e2774543b470cbd/transaction-2.0.3.tar.gz";
      sha256 = "67bfb81309ba9717edbb2ca2e5717c325b78beec0bf19f44e5b4b9410f82df7f";
    };
    propagatedBuildInputs = with pythonPackages; [
      zope_interface
      six
      wheel
      mock
    ];
    meta = with stdenv.lib; {
      homepage = "";
      license = licenses.zpt21;
      description = "Transaction management for Python";
    };
  };
}
