{ buildPythonPackage, fetchPypi, lib, isPy27, marshmallow, pytestCheckHook
, pytest-aiohttp, webtest, webtest-aiohttp, flask, django, bottle, tornado
, pyramid, falcon, aiohttp }:

buildPythonPackage rec {
  pname = "webargs";
  version = "8.0.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "bcce022250ee97cfbb0ad07b02388ac90a226ef4b479ec84317152345a565614";
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
