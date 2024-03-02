{ lib, buildPythonPackage, fetchPypi }:
buildPythonPackage rec {
  pname = "timeout-decorator";
  version = "0.5.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6a2f2f58db1c5b24a2cc79de6345760377ad8bdc13813f5265f6c3e63d16b3d7";
  };

  meta = with lib; {
    description = "Timeout decorator";
    license = licenses.mit;
    homepage = "https://github.com/pnpnpn/timeout-decorator";
  };
}
