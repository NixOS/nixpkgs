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
  requests,
  websocket-client,
  websockets,
}:

buildPythonPackage rec {
  pname = "sense-energy";
  version = "0.13.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scottbonline";
    repo = "sense";
    tag = version;
    hash = "sha256-hIE7wjKP+JcXQZ1lGbKCaKKK2ZlCF5BbJu3H7gqrsKU=";
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

  meta = {
    description = "API for the Sense Energy Monitor";
    homepage = "https://github.com/scottbonline/sense";
    changelog = "https://github.com/scottbonline/sense/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
