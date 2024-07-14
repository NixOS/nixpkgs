{
  stdenv,
  lib,
  fetchPypi,
  buildPythonPackage,
  pythonAtLeast,
  dnspython,
  pyasn1,
}:

buildPythonPackage rec {
  pname = "sleekxmpp";
  version = "1.3.3";
  format = "setuptools";

  disabled = pythonAtLeast "3.10"; # Deprecated in favor of Slixmpp

  propagatedBuildInputs = [
    dnspython
    pyasn1
  ];

  patches = [ ./dnspython-ip6.patch ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0hPB3nHZJQX5XO0EYO4PhP3E3crLfX3TQ3Oe1AKOVWk=";
  };

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    description = "XMPP library for Python";
    license = licenses.mit;
    homepage = "http://sleekxmpp.com/";
  };
}
