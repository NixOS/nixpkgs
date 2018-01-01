{ stdenv, buildPythonPackage, fetchPypi, ipaddress }:

buildPythonPackage rec {
  pname = "uritools";
  name = "uritools-${version}";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "97c74001adecce230299e2b916e95467ef7eed172fe67fd1f88b397cbc43a8e7";
  };

  propagatedBuildInputs = [ ipaddress ];

  meta = with stdenv.lib; {
    description = "RFC 3986 compliant, Unicode-aware, scheme-agnostic replacement for urlparse";
    license = licenses.mit;
    maintainers = [ maintainers.rvolosatovs ];
  };
}
