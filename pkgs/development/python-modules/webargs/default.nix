{
  lib,
  aiohttp,
  bottle,
  buildPythonPackage,
  django,
  falcon,
  fetchPypi,
  flask,
  flit-core,
  marshmallow,
  packaging,
  pkg-resources-backport,
  pyramid,
  pytest-aiohttp,
  pytestCheckHook,
  tornado,
  webtest-aiohttp,
  webtest,
}:

buildPythonPackage (finalAttrs: {
  pname = "webargs";
  version = "8.7.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-eZv5A5x2wj/Y3BlREHp1qeVhIDwV1q6PicHkbiNGNsE=";
  };

  build-system = [ flit-core ];

  dependencies = [
    marshmallow
    packaging
    pkg-resources-backport
  ];

  nativeCheckInputs = [
    aiohttp
    bottle
    django
    falcon
    flask
    pyramid
    pytest-aiohttp
    pytestCheckHook
    tornado
    webtest
    webtest-aiohttp
  ];

  pythonImportsCheck = [ "webargs" ];

  disabledTests = [
    # Tests is outdated
    "test_it_should_handle_type_error_on_load_json"
  ];

  meta = {
    description = "Declarative parsing and validation of HTTP request objects, with built-in support for popular web frameworks";
    homepage = "https://github.com/marshmallow-code/webargs";
    changelog = "https://github.com/marshmallow-code/webargs/blob/${finalAttrs.version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cript0nauta ];
  };
})
