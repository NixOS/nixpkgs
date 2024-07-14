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
    hash = "sha256-SyEguzOh2K2o+eBTKtmZh6oDh5sXsIv9xrgybW63wgU=";
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
