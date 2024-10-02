{
  buildPythonPackage,
  fetchPypi,
  lib,
  isPy27,
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
  version = "8.6.0";
  format = "setuptools";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uNCYq5K9dMZZ7KcFr6MdaBR18hjLFcHlcnH6IQPAVHo=";
  };

  pythonImportsCheck = [ "webargs" ];

  propagatedBuildInputs = [ marshmallow ];

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

  meta = with lib; {
    description = "Declarative parsing and validation of HTTP request objects, with built-in support for popular web frameworks";
    homepage = "https://github.com/marshmallow-code/webargs";
    license = licenses.mit;
    maintainers = with maintainers; [ cript0nauta ];
  };
}
