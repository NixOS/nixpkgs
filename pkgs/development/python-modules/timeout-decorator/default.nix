{ stdenv, buildPythonPackage, fetchPypi }:
buildPythonPackage rec {
  pname = "timeout-decorator";
  version = "0.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1inkf68i2s2x27arpqwkdxigiqbpbpjbbnfv7jzsrif1fmp2fphs";
  };

  meta = with stdenv.lib; {
    description = "Timeout decorator";
    license = licenses.mit;
    homepage = https://github.com/pnpnpn/timeout-decorator;
  };
}
