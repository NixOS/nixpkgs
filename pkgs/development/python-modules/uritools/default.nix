{ lib, buildPythonPackage, fetchPypi, isPy27 }:

buildPythonPackage rec {
  pname = "uritools";
  version = "3.0.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "a3e9c794d44fdbd54642dcb7d6ef3ba9866d953eb34f65aeca3754b7ad5c1ea0";
  };

  meta = with lib; {
    description = "RFC 3986 compliant, Unicode-aware, scheme-agnostic replacement for urlparse";
    license = licenses.mit;
    maintainers = [ maintainers.rvolosatovs ];
  };
}
