{
  lib,
  aiohttp,
  backoff,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  yarl,
  setuptools,
}:

buildPythonPackage rec {
  pname = "toonapi";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-toonapi";
    tag = "v${version}";
    hash = "sha256-RaN9ppqJbTik1/vNX0/YLoBawrqjyQWU6+FLTspIxug=";
  };

  patches = [
    # https://github.com/frenck/python-toonapi/pull/15
    (fetchpatch {
      name = "replace-async-timeout-with-asyncio.timeout.patch";
      url = "https://github.com/frenck/python-toonapi/commit/a04f1d8bcbcf48889dae49219d2edadbeb2dfa01.patch";
      hash = "sha256-EMK11M+2OTnIB7oWavpQKNQq0ZLuSxYQlC6On7ob1xU=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    backoff
    yarl
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "toonapi" ];

  meta = with lib; {
    description = "Python client for the Quby ToonAPI";
    homepage = "https://github.com/frenck/python-toonapi";
    changelog = "https://github.com/frenck/python-toonapi/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
