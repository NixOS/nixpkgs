{
  buildPythonPackage,
  lib,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "xstatic-bootbox";
  version = "5.5.1.1";

  src = fetchPypi {
    pname = "XStatic-Bootbox";
    inherit version;
    sha256 = "4b2120bb33a1d8ada8f9e0532ad99987aa03879b17b08bfdc6b8326d6eb7c205";
  };

  # no tests implemented
  doCheck = false;

  meta = with lib; {
    homepage = "http://bootboxjs.com";
    description = "Bootboxjs packaged static files for python";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };
}
