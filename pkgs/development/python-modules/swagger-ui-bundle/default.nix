{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build-system
  poetry-core,

  # dependencies
  importlib-resources,
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

  propagatedBuildInputs = [ jinja2 ] ++ lib.optionals (pythonOlder "3.9") [ importlib-resources ];

  # package contains no tests
  doCheck = false;

  meta = with lib; {
    description = "bundled swagger-ui pip package";
    homepage = "https://github.com/dtkav/swagger_ui_bundle";
    license = licenses.asl20;
  };
}
