{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  pname = "XStatic-Font-Awesome";
  version = "6.2.1.1";

  src = fetchPypi {
    inherit version pname;
    sha256 = "sha256-8HWHEJYShjjy4VOQINgid1TD2IXdaOfubemgEjUHaCg=";
  };

  # no tests implemented
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/python-xstatic/font-awesome";
    description = "Font Awesome packaged for python";
    license = licenses.ofl;
    maintainers = with maintainers; [ aither64 ];
  };
}
