{ stdenv
, buildPythonPackage
, fetchPypi
, nose
, forbiddenfruit
}:

buildPythonPackage rec {
  version = "0.1.0";
  pname = "shouldbe";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07pchxpv1xvjbck0xy44k3a1jrvklg0wbyccn14w0i7d135d4174";
  };

  buildInputs = [ nose ];
  propagatedBuildInputs = [ forbiddenfruit ];

  doCheck = false;  # Segmentation fault on py 3.5

  meta = with stdenv.lib; {
    description = "Python Assertion Helpers inspired by Shouldly";
    homepage =  https://pypi.python.org/pypi/shouldbe/;
    license = licenses.mit;
  };

}
