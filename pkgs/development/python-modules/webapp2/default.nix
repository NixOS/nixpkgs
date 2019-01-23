{ stdenv
, buildPythonPackage
, fetchPypi
, webob
, six
, jinja2
}:

buildPythonPackage rec {
  pname = "webapp2";
  version = "2.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "997db622a266bd64eb7fcc9cfe823efb69277544aa92064030c16acbfb2733a5";
  };

  # # error in tests when running with python 3+
  doCheck = false;

  propagatedBuildInputs = [ webob six ];

  meta = with stdenv.lib; {
    description = "Taking Google App Engine's webapp to the next level";
    homepage = http://webapp-improved.appspot.com;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
