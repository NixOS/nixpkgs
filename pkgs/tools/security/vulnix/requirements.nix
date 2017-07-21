{ pythonPackages, fetchurl, stdenv }:

rec {
  BTrees = pythonPackages.buildPythonPackage {
    name = "BTrees-4.3.1";
    src = fetchurl {
      url = "https://pypi.python.org/packages/24/76/cd6f225f2180c22af5cdb6656f51aec5fca45e45bdc4fa75c0a32f161a61/BTrees-4.3.1.tar.gz";
      sha256 = "2565b7d35260dfc6b1e2934470fd0a2f9326c58c535a2b4cb396289d1c195a95";
    };
    propagatedBuildInputs = [
      persistent
      transaction
    ] ++ (with pythonPackages; [ zope_interface coverage ]);

    meta = with stdenv.lib; {
      homepage = "";
      license = licenses.zpt21;
      description = "Scalable persistent object containers";
    };
  };

  ZConfig = pythonPackages.buildPythonPackage {
    name = "ZConfig-3.1.0";
    src = fetchurl {
      url = "https://pypi.python.org/packages/52/b3/a96d62711a26d8cfbe546519975dc9ed54d2eb50b3238d2e6de045764796/ZConfig-3.1.0.tar.gz";
      sha256 = "c21fa3a073a56925a8098036d46717392994a92cffea1b3cda3176b70c0a842e";
    };
    propagatedBuildInputs = with pythonPackages; [ zope_testrunner ];
    meta = with stdenv.lib; {
      homepage = "";
      license = licenses.zpt21;
      description = "Structured Configuration Library";
    };
  };

  zodb = pythonPackages.buildPythonPackage {
    name = "ZODB-5.2.0";
    src = fetchurl {
      url = "https://pypi.python.org/packages/1e/47/2f17075ca94a4a537ebd8e195c458456ef49aa67355ec805e478b8ad1959/ZODB-5.2.0.tar.gz";
      sha256 = "11l495lyym2fpvalj18yvcqwnsp8gyp18sgv5v575k4s2035lz0x";
    };
    doCheck = false;
    propagatedBuildInputs = [
      BTrees
      persistent
      transaction
      ZConfig
      zc.lockfile
      zodbpickle
    ] ++ (with pythonPackages; [ six wheel zope_interface ]);
    meta = with stdenv.lib; {
      homepage = "";
      license = licenses.zpt21;
      description = "Zope Object Database: object database and persistence";
    };
  };

  persistent = pythonPackages.buildPythonPackage {
    name = "persistent-4.2.2";
    src = fetchurl {
      url = "https://pypi.python.org/packages/3d/71/3302512282b606ec4d054e09be24c065915518903b29380b6573bff79c24/persistent-4.2.2.tar.gz";
      sha256 = "52ececc6dbba5ef572d3435189318b4dff07675bafa9620e32f785e147c6563c";
    };
    propagatedBuildInputs = with pythonPackages; [ zope_interface six wheel ];
    meta = with stdenv.lib; {
      homepage = "";
      license = licenses.zpt21;
      description = "Translucent persistent objects";
    };
  };

  transaction = pythonPackages.buildPythonPackage {
    name = "transaction-2.0.3";
    src = fetchurl {
      url = "https://pypi.python.org/packages/8c/af/3ffafe85bcc93ecb09459f3f2bd8fbe142e9ab34048f9e2774543b470cbd/transaction-2.0.3.tar.gz";
      sha256 = "67bfb81309ba9717edbb2ca2e5717c325b78beec0bf19f44e5b4b9410f82df7f";
    };
    propagatedBuildInputs = with pythonPackages; [ zope_interface six wheel ];
    meta = with stdenv.lib; {
      homepage = "";
      license = licenses.zpt21;
      description = "Transaction management for Python";
    };
  };

  zc.lockfile = pythonPackages.buildPythonPackage {
    name = "zc.lockfile-1.2.1";
    src = fetchurl {
      url = "https://pypi.python.org/packages/bd/84/0299bbabbc9d3f84f718ba1039cc068030d3ad723c08f82a64337edf901e/zc.lockfile-1.2.1.tar.gz";
      sha256 = "11db91ada7f22fe8aae268d4bfdeae012c4fe655f66bbb315b00822ec00d043e";
    };
    meta = with stdenv.lib; {
      homepage = "";
      license = licenses.zpt21;
      description = "Basic inter-process locks";
    };
  };

  zodbpickle = pythonPackages.buildPythonPackage {
    name = "zodbpickle-0.6.0";
    src = fetchurl {
      url = "https://pypi.python.org/packages/7a/fc/f6f437a5222b330735eaf8f1e67a6845bd1b600e9a9455e552d3c13c4902/zodbpickle-0.6.0.tar.gz";
      sha256 = "ea3248be966159e7791e3db0e35ea992b9235d52e7d39835438686741d196665";
    };
    doCheck = false;

    meta = with stdenv.lib; {
      homepage = "";
      license = licenses.zpt21;
      description = "Fork of Python 3 pickle module.";
    };
  };
}
