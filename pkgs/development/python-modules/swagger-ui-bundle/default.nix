{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  poetry-core,

  # dependencies
  jinja2,

}:

buildPythonPackage rec {
  pname = "swagger-ui-bundle";
  version = "1.1.0";
  pyproject = true;

  src = fetchPypi {
    pname = "swagger_ui_bundle";
    inherit version;
    hash = "sha256-IGc8NDHIcz1dFhXs952azzDP91ICrK8hp9nH9IlxRSk=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ jinja2 ];

  # package contains no tests
  doCheck = false;

  meta = {
    description = "Bundled swagger-ui pip package";
    homepage = "https://github.com/dtkav/swagger_ui_bundle";
    license = lib.licenses.asl20;
  };
}
