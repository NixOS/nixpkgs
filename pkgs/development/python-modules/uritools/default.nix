{ stdenv, buildPythonPackage, fetchPypi, ipaddress }:

buildPythonPackage rec {
  pname = "uritools";
  name = "uritools-${version}";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a7b58a249a851ef5fff1bc513b940653f0d4841a6668e02431c1297f05efeec3";
  };

  propagatedBuildInputs = [ ipaddress ];

  meta = with stdenv.lib; {
    description = "RFC 3986 compliant, Unicode-aware, scheme-agnostic replacement for urlparse";
    license = licenses.mit;
    maintainers = [ maintainers.rvolosatovs ];
  };
}
