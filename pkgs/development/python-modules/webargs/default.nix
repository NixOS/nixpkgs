{ buildPythonPackage, fetchPypi, lib, isPy27, marshmallow, pytestCheckHook
, pytest-aiohttp, webtest, webtest-aiohttp, flask, django, bottle, tornado
, pyramid, falcon, aiohttp }:

buildPythonPackage rec {
  pname = "webargs";
  version = "8.0.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0xy6na8axc5wnp2wg3kvqbpl2iv0hx0rsnlrmrgkgp88znx6cmjn";
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
