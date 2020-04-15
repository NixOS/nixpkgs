{ buildPythonPackage
, lib
, fetchPypi
}:

buildPythonPackage rec {
  pname = "XStatic-Bootbox";
  version = "4.4.0.1";

  src = fetchPypi {
    inherit version pname;
    sha256 = "1g00q38g1k576lxjlwglv4w3fj4z0z8lxlwpc66wyhjglj4r4bwd";
  };

  # no tests implemented
  doCheck = false;

  meta = with lib;{
    homepage = "http://bootboxjs.com";
    description = "Bootboxjs packaged static files for python";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };

}
