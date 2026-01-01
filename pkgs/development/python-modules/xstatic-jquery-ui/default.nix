{
  buildPythonPackage,
  lib,
  fetchPypi,
  xstatic-jquery,
}:

buildPythonPackage rec {
  pname = "xstatic-jquery-ui";
  version = "1.13.0.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "XStatic-jquery-ui";
    inherit version;
    sha256 = "3697e5f0ef355b8f4a1c724221592683c2db031935cbb57b46224eef474bd294";
  };

  # no tests implemented
  doCheck = false;

  propagatedBuildInputs = [ xstatic-jquery ];

<<<<<<< HEAD
  meta = {
    homepage = "https://jqueryui.com/";
    description = "jquery-ui packaged static files for python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ makefu ];
=======
  meta = with lib; {
    homepage = "https://jqueryui.com/";
    description = "jquery-ui packaged static files for python";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
