{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  pname = "XStatic-asciinema-player";
  version = "2.6.1.1";

  src = fetchPypi {
    inherit version pname;
    sha256 = "sha256-yA6WC067St82Dm6StaCKdWrRBhmNemswetIO8iodfcw=";
  };

  # no tests implemented
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/python-xstatic/asciinema-player";
    description = "Asciinema-player packaged for python";
    license = licenses.asl20;
    maintainers = with maintainers; [ aither64 ];
  };
}
