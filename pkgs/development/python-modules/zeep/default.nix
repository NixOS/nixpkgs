{
  lib,
  aiohttp,
  aioresponses,
  attrs,
  buildPythonPackage,
  defusedxml,
  fetchFromGitHub,
  freezegun,
  httpx,
  isodate,
  lxml,
  mock,
  platformdirs,
  pretend,
  pytest-asyncio,
  pytest-httpx,
  pytestCheckHook,
  pythonOlder,
  pytz,
  requests,
  requests-toolbelt,
  requests-file,
  requests-mock,
  xmlsec,
}:

buildPythonPackage rec {
  pname = "zeep";
  version = "4.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "mvantellingen";
    repo = "python-zeep";
    rev = "refs/tags/${version}";
    hash = "sha256-8f6kS231gbaZ8qyE8BKMcbnZsm8o2+iBoTlQrs5X+jY=";
  };

  propagatedBuildInputs = [
    attrs
    defusedxml
    isodate
    lxml
    platformdirs
    pytz
    requests
    requests-file
    requests-toolbelt
  ];

  passthru.optional-dependencies = {
    async_require = [ httpx ];
    xmlsec_require = [ xmlsec ];
  };

  pythonImportsCheck = [ "zeep" ];

  nativeCheckInputs = [
    aiohttp
    aioresponses
    freezegun
    mock
    pretend
    pytest-asyncio
    pytest-httpx
    pytestCheckHook
    requests-mock
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  disabledTests = [
    # Failed: External connections not allowed during tests.
    "test_has_expired"
    "test_has_not_expired"
    "test_memory_cache_timeout"
    "test_bytes_like_password_digest"
    "test_password_digest"
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  meta = with lib; {
    changelog = "https://github.com/mvantellingen/python-zeep/releases/tag/${version}";
    description = "Python SOAP client";
    homepage = "http://docs.python-zeep.org";
    license = licenses.mit;
  };
}
