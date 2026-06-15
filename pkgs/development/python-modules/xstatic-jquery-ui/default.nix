{
  buildPythonPackage,
  lib,
  fetchPypi,
  setuptools,
  xstatic-jquery,
}:

buildPythonPackage rec {
  pname = "xstatic-jquery-ui";
  version = "1.13.0.1";
  pyproject = true;

  src = fetchPypi {
    pname = "XStatic-jquery-ui";
    inherit version;
    sha256 = "3697e5f0ef355b8f4a1c724221592683c2db031935cbb57b46224eef474bd294";
  };

  build-system = [ setuptools ];

  # no tests implemented
  doCheck = false;

  dependencies = [ xstatic-jquery ];

  meta = {
    homepage = "https://jqueryui.com/";
    description = "jquery-ui packaged static files for python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ makefu ];
  };
}
