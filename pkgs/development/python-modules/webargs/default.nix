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
  fetchpatch,
}:

buildPythonPackage rec {
  pname = "webargs";
  version = "8.7.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DGF97BntTx/2skfNc4VelJ2HBS1xkAk4tx8Mr9kvGRs=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/marshmallow-code/webargs/commit/a6a5043ee34b0a22885b3625de6d4fdffc3b715b.patch";
      hash = "sha256-EFe76SAklgmBjfM6K8PkB0vHMCSlZ9EKAW9AbnxKmPA=";
    })
  ];

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
