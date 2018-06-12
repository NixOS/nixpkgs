{ stdenv, buildPythonPackage, fetchPypi, ipaddress }:

buildPythonPackage rec {
  pname = "uritools";
  version = "2.2.0";
  name = pname + "-" + version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "80e8e23cafad54fd85811b5d9ba0fc595d933f5727c61c3937945eec09f99e2b";
  };

  propagatedBuildInputs = [ ipaddress ];

  meta = with stdenv.lib; {
    description = "RFC 3986 compliant, Unicode-aware, scheme-agnostic replacement for urlparse";
    license = licenses.mit;
    maintainers = [ maintainers.rvolosatovs ];
  };
}
