{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  jinja2,
  packaging,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "swagger-ui-py";
  version = "25.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PWZER";
    repo = "swagger-ui-py";
    tag = "v${version}";
    hash = "sha256-yPGt7EG8KvGoI7Unz0E7fn7nG9Ei/h8Q3TDKnuVVRkQ=";
  };

  env.VERSION = version;

  build-system = [
    setuptools
  ];

  dependencies = [
    jinja2
    packaging
    pyyaml
  ];

  doCheck = false; # huge dependency closure on all sorts of web frameworks, http clients, etc.

  pythonImportsCheck = [
    "swagger_ui"
  ];

  meta = {
    changelog = "https://github.com/PWZER/swagger-ui-py/releases/tag/${src.tag}";
    description = "Swagger UI for Python web framework, such Tornado, Flask and Sanic. https://pwzer.github.io/swagger-ui-py";
    homepage = "https://github.com/PWZER/swagger-ui-py";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
