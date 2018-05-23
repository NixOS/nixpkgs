{ stdenv, buildPythonPackage, fetchPypi }:
buildPythonPackage rec {
  pname = "timeout-decorator";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bckwbi5078z3x9lyf8vl9dhx10nymwwnp46c98wm5m02x5j37g4";
  };

  meta = with stdenv.lib; {
    description = "Timeout decorator";
    license = licenses.mit;
    homepage = https://github.com/pnpnpn/timeout-decorator;
  };
}
