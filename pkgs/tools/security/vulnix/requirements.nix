{ buildPythonPackage, commonDoCheck ? false, commonBuildInputs ? [], fetchurl, libxml2, libxslt, stdenv }:

rec {

  BTrees = buildPythonPackage {
    name = "BTrees-4.3.1";
    src = fetchurl {
      url = "https://pypi.python.org/packages/24/76/cd6f225f2180c22af5cdb6656f51aec5fca45e45bdc4fa75c0a32f161a61/BTrees-4.3.1.tar.gz";
      sha256 = "2565b7d35260dfc6b1e2934470fd0a2f9326c58c535a2b4cb396289d1c195a95";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [
      coverage
      persistent
      transaction
      zope.interface
    ];
    meta = with stdenv.lib; {
      homepage = "";
      license = licenses.zpt21;
      description = "Scalable persistent object containers";
    };
  };



  PyYAML = buildPythonPackage {
    name = "PyYAML-3.11";
    src = fetchurl {
      url = "https://pypi.python.org/packages/75/5e/b84feba55e20f8da46ead76f14a3943c8cb722d40360702b2365b91dec00/PyYAML-3.11.tar.gz";
      sha256 = "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with stdenv.lib; {
      homepage = "";
      license = licenses.mit;
      description = "YAML parser and emitter for Python";
    };
  };



  ZConfig = buildPythonPackage {
    name = "ZConfig-3.1.0";
    src = fetchurl {
      url = "https://pypi.python.org/packages/52/b3/a96d62711a26d8cfbe546519975dc9ed54d2eb50b3238d2e6de045764796/ZConfig-3.1.0.tar.gz";
      sha256 = "c21fa3a073a56925a8098036d46717392994a92cffea1b3cda3176b70c0a842e";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with stdenv.lib; {
      homepage = "";
      license = licenses.zpt21;
      description = "Structured Configuration Library";
    };
  };



  ZODB = buildPythonPackage {
    name = "ZODB-5.1.1";
    src = fetchurl {
      url = "https://pypi.python.org/packages/08/67/62d42c704edd64bcecddc29442a70535ebc7af46e232a5efa9fc572953f0/ZODB-5.1.1.tar.gz";
      sha256 = "b0bbe6dfe60e2bdcf842a87abcc53b5cd15ad88ae2824c0c526cbb01ca0b90e5";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [
      BTrees
      ZConfig
      persistent
      six
      transaction
      zc.lockfile
      zodbpickle
      zope.interface
    ];
    meta = with stdenv.lib; {
      homepage = "";
      license = licenses.zpt21;
      description = "Zope Object Database: object database and persistence";
    };
  };



  click = buildPythonPackage {
    name = "click-6.6";
    src = fetchurl {
      url = "https://pypi.python.org/packages/7a/00/c14926d8232b36b08218067bcd5853caefb4737cda3f0a47437151344792/click-6.6.tar.gz";
      sha256 = "cc6a19da8ebff6e7074f731447ef7e112bd23adf3de5c597cf9989f2fd8defe9";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with stdenv.lib; {
      homepage = "";
      license = licenses.bsdOriginal;
      description = "A simple wrapper around optparse for powerful command line utilities.";
    };
  };



  colorama = buildPythonPackage {
    name = "colorama-0.3.7";
    src = fetchurl {
      url = "https://pypi.python.org/packages/f0/d0/21c6449df0ca9da74859edc40208b3a57df9aca7323118c913e58d442030/colorama-0.3.7.tar.gz";
      sha256 = "e043c8d32527607223652021ff648fbb394d5e19cba9f1a698670b338c9d782b";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with stdenv.lib; {
      homepage = "";
      license = licenses.bsdOriginal;
      description = "Cross-platform colored terminal text.";
    };
  };



  coverage = buildPythonPackage {
    name = "coverage-4.0.3";
    src = fetchurl {
      url = "https://pypi.python.org/packages/76/b4/3777a6bae434240b1fcbbda6cb30085bd897b3519acfffea498ee9f41038/coverage-4.0.3.tar.gz";
      sha256 = "85b1275b6d7a61ccc8024a4e9a4c9e896394776edce1a5d075ec116f91925462";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with stdenv.lib; {
      homepage = "";
      license = licenses.asl20;
      description = "Code coverage measurement for Python";
    };
  };



  flake8 = buildPythonPackage {
    name = "flake8-2.5.4";
    src = fetchurl {
      url = "https://pypi.python.org/packages/60/4a/7b0ac4920af5673380b7079ba2f7580a8645790c7718881082c0d918b8b4/flake8-2.5.4.tar.gz";
      sha256 = "cc1e58179f6cf10524c7bfdd378f5536d0a61497688517791639a5ecc867492f";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [
      "mccabe"
      "pep8"
      "pyflakes"
    ];
    meta = with stdenv.lib; {
      homepage = "";
      license = licenses.mit;
      description = "the modular source code checker: pep8, pyflakes and co";
    };
  };



  lxml = buildPythonPackage {
    name = "lxml-3.7.0";
    src = fetchurl {
      url = "https://pypi.python.org/packages/14/51/61462e59ab58575fe0d679ab2d31ec73cd49b26182c6ece3d9379faccfd7/lxml-3.7.0.tar.gz";
      sha256 = "9c62eb2a1862e1ae285d7e7e3b7dc8772d387b19258086afcec143c6b7b8a5c9";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ libxml2 libxslt ];
    meta = with stdenv.lib; {
      homepage = "";
      license = licenses.bsdOriginal;
      description = "Powerful and Pythonic XML processing library combining libxml2/libxslt with the ElementTree API.";
    };
  };



  mccabe = buildPythonPackage {
    name = "mccabe-0.4.0";
    src = fetchurl {
      url = "https://pypi.python.org/packages/f6/e7/54461a958bb8b16f8db5f849d5d08b7d74153e064ac385fb68ff09f0bd27/mccabe-0.4.0.tar.gz";
      sha256 = "9a2b12ebd876e77c72e41ebf401cc2e7c5b566649d50105ca49822688642207b";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with stdenv.lib; {
      homepage = "";
      license = licenses.mit;
      description = "McCabe checker, plugin for flake8";
    };
  };



  pep8 = buildPythonPackage {
    name = "pep8-1.7.0";
    src = fetchurl {
      url = "https://pypi.python.org/packages/3e/b5/1f717b85fbf5d43d81e3c603a7a2f64c9f1dabc69a1e7745bd394cc06404/pep8-1.7.0.tar.gz";
      sha256 = "a113d5f5ad7a7abacef9df5ec3f2af23a20a28005921577b15dd584d099d5900";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with stdenv.lib; {
      homepage = "";
      license = licenses.mit;
      description = "Python style guide checker";
    };
  };



  persistent = buildPythonPackage {
    name = "persistent-4.2.2";
    src = fetchurl {
      url = "https://pypi.python.org/packages/3d/71/3302512282b606ec4d054e09be24c065915518903b29380b6573bff79c24/persistent-4.2.2.tar.gz";
      sha256 = "52ececc6dbba5ef572d3435189318b4dff07675bafa9620e32f785e147c6563c";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [
      coverage
      zope.interface
    ];
    meta = with stdenv.lib; {
      homepage = "";
      license = licenses.zpt21;
      description = "Translucent persistent objects";
    };
  };



  py = buildPythonPackage {
    name = "py-1.4.31";
    src = fetchurl {
      url = "https://pypi.python.org/packages/f4/9a/8dfda23f36600dd701c6722316ba8a3ab4b990261f83e7d3ffc6dfedf7ef/py-1.4.31.tar.gz";
      sha256 = "a6501963c725fc2554dabfece8ae9a8fb5e149c0ac0a42fd2b02c5c1c57fc114";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with stdenv.lib; {
      homepage = "";
      license = licenses.mit;
      description = "library with cross-python path, ini-parsing, io, code, log facilities";
    };
  };



  pyflakes = buildPythonPackage {
    name = "pyflakes-1.0.0";
    src = fetchurl {
      url = "https://pypi.python.org/packages/45/24/6bc038f3422bab08c24173c1990a56e9eb0c4582a9b202858a33f8aefeb8/pyflakes-1.0.0.tar.gz";
      sha256 = "f39e33a4c03beead8774f005bd3ecf0c3f2f264fa0201de965fce0aff1d34263";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with stdenv.lib; {
      homepage = "";
      license = licenses.mit;
      description = "passive checker of Python programs";
    };
  };



  pytest = buildPythonPackage {
    name = "pytest-2.9.1";
    src = fetchurl {
      url = "https://pypi.python.org/packages/5e/f0/75c5cee17575bef459c916b6276bd9ad56944836bb0d9e36dd05704e7f35/pytest-2.9.1.tar.gz";
      sha256 = "0d48d27a127644fbe7c8158157e08b35f8255045d4476df694b91eb3a8147e65";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [
      "colorama"
      "py"
    ];
    meta = with stdenv.lib; {
      homepage = "";
      license = licenses.mit;
      description = "pytest: simple powerful testing with Python";
    };
  };



  pytest-capturelog = buildPythonPackage {
    name = "pytest-capturelog-0.7";
    src = fetchurl {
      url = "https://pypi.python.org/packages/35/e9/6051b5bb65ad5049d5eb60127d34c63ba724e17acf8b1f2f2e0755131b6c/pytest-capturelog-0.7.tar.gz";
      sha256 = "b6e8d5189b39462109c2188e6b512d6cc7e66d62bb5be65389ed50e96d22000d";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [
      "py"
    ];
    meta = with stdenv.lib; {
      homepage = "";
      license = licenses.mit;
      description = "py.test plugin to capture log messages";
    };
  };



  pytest-codecheckers = buildPythonPackage {
    name = "pytest-codecheckers-0.2";
    src = fetchurl {
      url = "https://pypi.python.org/packages/53/09/263669db13955496e77017f389693c1e1dd77d98fd4afd51b133162e858f/pytest-codecheckers-0.2.tar.gz";
      sha256 = "853de10f204865140da2bc173f791c9e13794fc43656e02fffcce23c9999e748";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [
      "pep8"
      "py"
      "pyflakes"
    ];
    meta = with stdenv.lib; {
      homepage = "";
      license = "";
      description = "pytest plugin to add source code sanity checks (pep8 and friends)";
    };
  };



  pytest-cov = buildPythonPackage {
    name = "pytest-cov-2.2.1";
    src = fetchurl {
      url = "https://pypi.python.org/packages/39/07/bdd2d985ae7ac726cc5e7a6a343b585570bf1f9f7cb297a9cd58a60c7c89/pytest-cov-2.2.1.tar.gz";
      sha256 = "a8b22e53e7f3b971454c35df99dffe21f4749f539491e935c55d3ff7e1b284fa";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [
      "coverage"
      "pytest"
    ];
    meta = with stdenv.lib; {
      homepage = "";
      license = licenses.bsdOriginal;
      description = "Pytest plugin for measuring coverage.";
    };
  };



  pytest-runner = buildPythonPackage {
    name = "pytest-runner-2.9";
    src = fetchurl {
      url = "https://pypi.python.org/packages/11/d4/c335ddf94463e451109e3494e909765c3e5205787b772e3b25ee8601b86a/pytest-runner-2.9.tar.gz";
      sha256 = "50378de59b02f51f64796d3904dfe71b9dc6f06d88fc6bfbd5c8e8366ae1d131";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with stdenv.lib; {
      homepage = "";
      license = licenses.mit;
      description = "Invoke py.test as distutils command with dependency resolution";
    };
  };



  pytest-timeout = buildPythonPackage {
    name = "pytest-timeout-1.0.0";
    src = fetchurl {
      url = "https://pypi.python.org/packages/cf/92/ab29b9baa54d47dfd50e43be35577de9af4e7ebf27d29f546ddeb6c3b6f5/pytest-timeout-1.0.0.tar.gz";
      sha256 = "1465096be73e16df1e15d1b1453692428a7e15b997d756bc565aee0d12798ce1";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [
      "pytest"
    ];
    meta = with stdenv.lib; {
      homepage = "";
      license = licenses.mit;
      description = "py.test plugin to abort hanging tests";
    };
  };



  requests = buildPythonPackage {
    name = "requests-2.10.0";
    src = fetchurl {
      url = "https://pypi.python.org/packages/49/6f/183063f01aae1e025cf0130772b55848750a2f3a89bfa11b385b35d7329d/requests-2.10.0.tar.gz";
      sha256 = "63f1815788157130cee16a933b2ee184038e975f0017306d723ac326b5525b54";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with stdenv.lib; {
      homepage = "";
      license = licenses.asl20;
      description = "Python HTTP for Humans.";
    };
  };



  setuptools-scm = buildPythonPackage {
    name = "setuptools-scm-1.15.0";
    src = fetchurl {
      url = "https://pypi.python.org/packages/80/b7/31b6ae5fcb188e37f7e31abe75f9be90490a5456a72860fa6e643f8a3cbc/setuptools_scm-1.15.0.tar.gz";
      sha256 = "daf12d05aa2155a46aa357453757ffdc47d87f839e62114f042bceac6a619e2f";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with stdenv.lib; {
      homepage = "";
      license = licenses.mit;
      description = "the blessed package to manage your versions by scm tags";
    };
  };



  six = buildPythonPackage {
    name = "six-1.10.0";
    src = fetchurl {
      url = "https://pypi.python.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz";
      sha256 = "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with stdenv.lib; {
      homepage = "";
      license = licenses.mit;
      description = "Python 2 and 3 compatibility utilities";
    };
  };



  transaction = buildPythonPackage {
    name = "transaction-2.0.3";
    src = fetchurl {
      url = "https://pypi.python.org/packages/8c/af/3ffafe85bcc93ecb09459f3f2bd8fbe142e9ab34048f9e2774543b470cbd/transaction-2.0.3.tar.gz";
      sha256 = "67bfb81309ba9717edbb2ca2e5717c325b78beec0bf19f44e5b4b9410f82df7f";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [
      coverage
      zope.interface
    ];
    meta = with stdenv.lib; {
      homepage = "";
      license = licenses.zpt21;
      description = "Transaction management for Python";
    };
  };



  zc.lockfile = buildPythonPackage {
    name = "zc.lockfile-1.2.1";
    src = fetchurl {
      url = "https://pypi.python.org/packages/bd/84/0299bbabbc9d3f84f718ba1039cc068030d3ad723c08f82a64337edf901e/zc.lockfile-1.2.1.tar.gz";
      sha256 = "11db91ada7f22fe8aae268d4bfdeae012c4fe655f66bbb315b00822ec00d043e";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [ ];
    meta = with stdenv.lib; {
      homepage = "";
      license = licenses.zpt21;
      description = "Basic inter-process locks";
    };
  };



  zodbpickle = buildPythonPackage {
    name = "zodbpickle-0.6.0";
    src = fetchurl {
      url = "https://pypi.python.org/packages/7a/fc/f6f437a5222b330735eaf8f1e67a6845bd1b600e9a9455e552d3c13c4902/zodbpickle-0.6.0.tar.gz";
      sha256 = "ea3248be966159e7791e3db0e35ea992b9235d52e7d39835438686741d196665";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [
      coverage
    ];
    meta = with stdenv.lib; {
      homepage = "";
      license = licenses.zpt21;
      description = "Fork of Python 3 pickle module.";
    };
  };



  zope.interface = buildPythonPackage {
    name = "zope.interface-4.3.3";
    src = fetchurl {
      url = "https://pypi.python.org/packages/44/af/cea1e18bc0d3be0e0824762d3236f0e61088eeed75287e7b854d65ec9916/zope.interface-4.3.3.tar.gz";
      sha256 = "8780ef68ca8c3fe1abb30c058a59015129d6e04a6b02c2e56b9c7de6078dfa88";
    };
    doCheck = commonDoCheck;
    buildInputs = commonBuildInputs;
    propagatedBuildInputs = [
      coverage
    ];
    meta = with stdenv.lib; {
      homepage = "";
      license = licenses.zpt21;
      description = "Interfaces for Python";
    };
  };

}