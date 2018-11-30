{ stdenv
, buildPythonPackage
, fetchPypi
, six
, webob
}:

buildPythonPackage rec {
  pname = "WSGIProxy2";
  version = "0.4.2";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "13kf9bdxrc95y9vriaz0viry3ah11nz4rlrykcfvb8nlqpx3dcm4";
  };

  propagatedBuildInputs = [ six webob ];

  # circular dep on webtest
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://pythonpaste.org/wsgiproxy/;
    description = "HTTP proxying tools for WSGI apps";
    license = licenses.mit;
    maintainers = with maintainers; [ garbas domenkozar ];
  };

}
