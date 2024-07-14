{
  buildPythonPackage,
  lib,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "xstatic-jquery";
  version = "3.5.1.1";

  src = fetchPypi {
    pname = "XStatic-jQuery";
    inherit version;
    hash = "sha256-4K6PjsW70oBFukvKBnZ6OL1fwnz5tx9DRYn1k3Dc0yM=";
  };

  # no tests implemented
  doCheck = false;

  meta = with lib; {
    homepage = "https://jquery.org";
    description = "jquery packaged static files for python";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };
}
