{ lib, buildPythonPackage, fetchPypi, isPy27 }:

buildPythonPackage rec {
  pname = "uritools";
  version = "4.0.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "420d94c1ff4bf90c678fca9c17b8314243bbcaa992c400a95e327f7f622e1edf";
  };

  meta = with lib; {
    description = "RFC 3986 compliant, Unicode-aware, scheme-agnostic replacement for urlparse";
    license = licenses.mit;
    maintainers = [ maintainers.rvolosatovs ];
  };
}
