{ stdenv, buildPythonPackage, fetchPypi, ipaddress }:

buildPythonPackage rec {
  pname = "uritools";
  name = "uritools-${version}";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "20d7881a947cd3c3bb452e2b541f44acc52febe9c4e3f6d05c55d559fb208c50";
  };

  propagatedBuildInputs = [ ipaddress ];

  meta = with stdenv.lib; {
    description = "RFC 3986 compliant, Unicode-aware, scheme-agnostic replacement for urlparse";
    license = licenses.mit;
    maintainers = [ maintainers.rvolosatovs ];
  };
}
