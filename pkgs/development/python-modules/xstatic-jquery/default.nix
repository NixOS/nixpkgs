{
  buildPythonPackage,
  lib,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "xstatic-jquery";
  version = "3.5.1.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "XStatic-jQuery";
    inherit version;
    sha256 = "e0ae8f8ec5bbd28045ba4bca06767a38bd5fc27cf9b71f434589f59370dcd323";
  };

  # no tests implemented
  doCheck = false;

<<<<<<< HEAD
  meta = {
    homepage = "https://jquery.org";
    description = "jquery packaged static files for python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ makefu ];
=======
  meta = with lib; {
    homepage = "https://jquery.org";
    description = "jquery packaged static files for python";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
