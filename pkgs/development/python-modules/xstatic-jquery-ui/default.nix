{
  buildPythonPackage,
  lib,
  fetchPypi,
  setuptools,
  xstatic-jquery,
}:

buildPythonPackage (finalAttrs: {
  pname = "xstatic-jquery-ui";
  version = "1.13.0.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "XStatic-jquery-ui";
    inherit (finalAttrs) version;
    hash = "sha256-Npfl8O81W49KHHJCIVkmg8LbAxk1y7V7RiJO70dL0pQ=";
  };

  build-system = [ setuptools ];

  # no tests implemented
  doCheck = false;

  dependencies = [ xstatic-jquery ];

  pythonImportsCheck = [ "xstatic.pkg.jquery_ui" ];

  meta = {
    homepage = "https://jqueryui.com/";
    description = "jquery-ui packaged static files for python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ makefu ];
  };
})
