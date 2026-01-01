{
  buildPythonPackage,
  lib,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "xstatic-asciinema-player";
  version = "2.6.1.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "XStatic-asciinema-player";
    inherit version;
    hash = "sha256-yA6WC067St82Dm6StaCKdWrRBhmNemswetIO8iodfcw=";
  };

  # no tests implemented
  doCheck = false;

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/python-xstatic/asciinema-player";
    description = "Asciinema-player packaged for python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aither64 ];
=======
  meta = with lib; {
    homepage = "https://github.com/python-xstatic/asciinema-player";
    description = "Asciinema-player packaged for python";
    license = licenses.asl20;
    maintainers = with maintainers; [ aither64 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
