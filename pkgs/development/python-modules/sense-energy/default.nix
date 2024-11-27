{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  ciso8601,
  async-timeout,
  kasa-crypt,
  orjson,
  pythonOlder,
  requests,
  websocket-client,
  websockets,
}:

buildPythonPackage rec {
  pname = "sense-energy";
  version = "0.13.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "scottbonline";
    repo = "sense";
    rev = "refs/tags/${version}";
    hash = "sha256-WzhLHFOL0DY6DfDxRZlhcXXfiHWAg1jzXHtXBmmbAbQ=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "{{VERSION_PLACEHOLDER}}" "${version}"
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    async-timeout
    kasa-crypt
    orjson
    ciso8601
    requests
    websocket-client
    websockets
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "sense_energy" ];

  meta = with lib; {
    description = "API for the Sense Energy Monitor";
    homepage = "https://github.com/scottbonline/sense";
    changelog = "https://github.com/scottbonline/sense/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
