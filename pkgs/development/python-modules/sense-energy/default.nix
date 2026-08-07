{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  ciso8601,
  async-timeout,
  kasa-crypt,
  msgpack,
  orjson,
  requests,
  websocket-client,
  websockets,
}:

buildPythonPackage (finalAttrs: {
  pname = "sense-energy";
  version = "0.14.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scottbonline";
    repo = "sense";
    tag = finalAttrs.version;
    hash = "sha256-Ug58qKlFBe4DpAKMWNup7A2QTslGaaY2OMPyJtnfWfM=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "{{VERSION_PLACEHOLDER}}" "${finalAttrs.version}"
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    async-timeout
    kasa-crypt
    msgpack
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
    changelog = "https://github.com/scottbonline/sense/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
