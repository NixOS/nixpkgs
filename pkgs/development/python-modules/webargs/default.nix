{ buildPythonPackage, fetchPypi, lib, isPy27, marshmallow, pytestCheckHook
, pytest-aiohttp, webtest, webtest-aiohttp, flask, django, bottle, tornado
, pyramid, falcon, aiohttp }:

buildPythonPackage rec {
  pname = "webargs";
  version = "8.1.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "f1f0b7f054a22263cf750529fc0926709ca47da9a2c417d423ad88d9fa6a5d33";
  };

  pythonImportsCheck = [
    "webargs"
  ];

  propagatedBuildInputs = [ marshmallow ];

  checkInputs = [
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
