{ stdenv, buildPythonPackage, fetchPypi, isPy3k, ipaddress }:

buildPythonPackage rec {
  pname = "uritools";
  version = "2.2.0";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0awyz44yqpll6wwirii7awzr6parzjh9np8vh62zsm5dmwyf5s40";
  };

  propagatedBuildInputs = [ ipaddress ];

  meta = with stdenv.lib; {
    description = "RFC 3986 compliant, Unicode-aware, scheme-agnostic replacement for urlparse";
    license = licenses.mit;
    maintainers = [ maintainers.rvolosatovs ];
  };
}
