{ stdenv
, buildPythonPackage
, fetchPypi
, paste
, six
, isPy3k
}:

buildPythonPackage rec {
  pname = "WSGIProxy";
  version = "0.2.2";
  disabled = isPy3k; # Judging from SyntaxError

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wqz1q8cvb81a37gb4kkxxpv4w7k8192a08qzyz67rn68ln2wcig";
  };

  propagatedBuildInputs = [ paste six ];

  meta = with stdenv.lib; {
    description = "WSGIProxy gives tools to proxy arbitrary(ish) WSGI requests to other";
    homepage = "http://pythonpaste.org/wsgiproxy/";
    license = licenses.mit;
  };

}
