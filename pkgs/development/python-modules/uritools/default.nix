{ stdenv, buildPythonPackage, fetchPypi, ipaddress }:

buildPythonPackage rec {
  pname = "uritools";
  version = "2.1.1";
  name = pname + "-" + version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "64369ece6f5c6ab18cba2cd0b199da40ffb9390493da1ff5c1d94b6ed107b401";
  };

  propagatedBuildInputs = [ ipaddress ];

  meta = with stdenv.lib; {
    description = "RFC 3986 compliant, Unicode-aware, scheme-agnostic replacement for urlparse";
    license = licenses.mit;
    maintainers = [ maintainers.rvolosatovs ];
  };
}
