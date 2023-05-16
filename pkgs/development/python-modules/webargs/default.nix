{ buildPythonPackage, fetchPypi, lib, isPy27, marshmallow, pytestCheckHook
, pytest-aiohttp, webtest, webtest-aiohttp, flask, django, bottle, tornado
, pyramid, falcon, aiohttp }:

buildPythonPackage rec {
  pname = "webargs";
<<<<<<< HEAD
  version = "8.3.0";
=======
  version = "8.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-yrIHlBsGhsTQhsgjYy3c1DQxUWRDQaMvz1C46qceMcc=";
=======
    hash = "sha256-mdaJQMRS4HcmSFoV/vQ/EviubAxbORvLp2Bl1FJ/uF0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
