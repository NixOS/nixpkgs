{ lib, buildPythonPackage, fetchPypi, isPy27 }:

buildPythonPackage rec {
  pname = "uritools";
  version = "3.0.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "28ffef82ce3b2793237d36e45aa7cde28dae6502f6a93fdbd05ede401520e279";
  };

  meta = with lib; {
    description = "RFC 3986 compliant, Unicode-aware, scheme-agnostic replacement for urlparse";
    license = licenses.mit;
    maintainers = [ maintainers.rvolosatovs ];
  };
}
