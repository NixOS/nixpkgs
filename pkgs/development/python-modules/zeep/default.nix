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
  packaging,
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
  setuptools,
  xmlsec,
}:

buildPythonPackage rec {
  pname = "zeep";
  version = "4.3.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "mvantellingen";
    repo = "python-zeep";
    tag = version;
    hash = "sha256-Bt0QqzJMKPXV91hZYETy9DKoQAELUWlYIh8w/IFTE8E=";
  };

  patches = [ ./httpx-compat.patch ];

  build-system = [ setuptools ];

  dependencies = [
    attrs
    defusedxml
    isodate
    lxml
    packaging
    platformdirs
    pytz
    requests
    requests-file
    requests-toolbelt
  ];

  optional-dependencies = {
    async = [ httpx ];
    xmlsec = [ xmlsec ];
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
  ]
<<<<<<< HEAD
  ++ lib.concatAttrValues optional-dependencies;
=======
  ++ lib.flatten (builtins.attrValues optional-dependencies);
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/mvantellingen/python-zeep/releases/tag/${version}";
    description = "Python SOAP client";
    homepage = "http://docs.python-zeep.org";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    changelog = "https://github.com/mvantellingen/python-zeep/releases/tag/${version}";
    description = "Python SOAP client";
    homepage = "http://docs.python-zeep.org";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
