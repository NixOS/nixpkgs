{ stdenv, fetchPypi, buildPythonPackage, user-agents }:

buildPythonPackage rec {
  pname = "home-assistant-frontend";
  version = "20180607.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "22ac0b7615c9c7e6700db250079d8a1041c8d40788375402701adaace8b21889";
  };

  propagatedBuildInputs = [ user-agents ];
}
