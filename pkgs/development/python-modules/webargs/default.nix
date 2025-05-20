{
  buildPythonPackage,
  fetchPypi,
  lib,
  pythonAtLeast,
  flit-core,
  marshmallow,
  pytestCheckHook,
  pytest-aiohttp,
  webtest,
  webtest-aiohttp,
  flask,
  django,
  bottle,
  tornado,
  pyramid,
  falcon,
  aiohttp,
}:

buildPythonPackage rec {
  pname = "webargs";
  version = "8.7.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DGF97BntTx/2skfNc4VelJ2HBS1xkAk4tx8Mr9kvGRs=";
  };

  build-system = [ flit-core ];

  dependencies = [ marshmallow ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-aiohttp
    webtest
    webtest-aiohttp
    flask
    django
    bottle
    tornado
    pyramid
    falcon
    aiohttp
  ];

  pythonImportsCheck = [ "webargs" ];

  meta = with lib; {
    description = "Declarative parsing and validation of HTTP request objects, with built-in support for popular web frameworks";
    homepage = "https://github.com/marshmallow-code/webargs";
    license = licenses.mit;
    maintainers = with maintainers; [ cript0nauta ];
  };
}
