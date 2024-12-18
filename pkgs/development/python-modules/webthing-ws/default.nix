{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "webthing-ws";
  version = "0.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-j7nc4yJczDs28RVFDHeQ2ZIG9mIW2m25AAeErVKi4E4=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "webthing_ws" ];

  meta = with lib; {
    description = "WebThing WebSocket consumer and API client";
    homepage = "https://github.com/home-assistant-ecosystem/webthing-ws";
    changelog = "https://github.com/home-assistant-ecosystem/webthing-ws/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
