{ lib
, buildPythonPackage
, fetchFromGitHub
, jinja2
, pyyaml
, pytestCheckHook
, requests
, uvicorn
, tornado
, flask
, falcon
, aiohttp
, bottle
, sanic
, quart
, starlette
, chalice
}:

buildPythonPackage rec {
  pname = "swagger-ui-py";
  version = "22.07.13";

  src = fetchFromGitHub {
    owner = "PWZER";
    repo = "swagger-ui-py";
    rev = "refs/tags/v${version}";
    hash = "sha256-Mf4pPUsQp7DN6QU31bLx2F5TBhPsDjkEuvGCkakRFPU=";
  };

  propagatedBuildInputs = [ jinja2 pyyaml ];

  checkInputs = [
    pytestCheckHook
    requests
    uvicorn
    tornado
    flask
    falcon
    aiohttp
    bottle
    sanic
    quart
    starlette
    chalice
  ];

  # TODO check phase hangs
  doCheck = false;

  meta = with lib; {
    changelog = "https://github.com/PWZER/swagger-ui-py/releases/tag/v${version}";
    description = "Swagger UI for Python web framework, such Tornado, Flask and Sanic.";
    homepage = "https://pwzer.github.io/swagger-ui-py/";
    license = licenses.asl20;
    maintainers = with maintainers; [ felschr ];
  };
}
