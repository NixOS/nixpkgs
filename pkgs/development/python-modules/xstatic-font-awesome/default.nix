{
  buildPythonPackage,
  lib,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "xstatic-font-awesome";
  version = "6.2.1.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "XStatic-Font-Awesome";
    inherit version;
    hash = "sha256-8HWHEJYShjjy4VOQINgid1TD2IXdaOfubemgEjUHaCg=";
  };

  # no tests implemented
  doCheck = false;

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/python-xstatic/font-awesome";
    description = "Font Awesome packaged for python";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ aither64 ];
=======
  meta = with lib; {
    homepage = "https://github.com/python-xstatic/font-awesome";
    description = "Font Awesome packaged for python";
    license = licenses.ofl;
    maintainers = with maintainers; [ aither64 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
