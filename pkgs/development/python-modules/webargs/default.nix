{ buildPythonPackage, fetchPypi, lib, isPy27, marshmallow, pytestCheckHook
, pytest-aiohttp, webtest, webtest-aiohttp, flask, django, bottle, tornado
, pyramid, falcon, aiohttp }:

buildPythonPackage rec {
  pname = "webargs";
  version = "8.4.0";
  format = "setuptools";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6pk2ghSkzmE5JL6Z1x21jCaWMele/0+gm3NU5S3ABqU=";
  };

  pythonImportsCheck = [
    "webargs"
  ];

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
