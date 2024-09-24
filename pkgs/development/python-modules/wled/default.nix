{
  lib,
  aiohttp,
  aresponses,
  awesomeversion,
  backoff,
  buildPythonPackage,
  cachetools,
  fetchFromGitHub,
  mashumaro,
  orjson,
  poetry-core,
  pytest-asyncio,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  typer,
  yarl,
  zeroconf,
}:

buildPythonPackage rec {
  pname = "wled";
  version = "0.20.2";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-wled";
    rev = "refs/tags/v${version}";
    hash = "sha256-7P/V83dGkfJJjZxZtiEwQXIY7CeBZ/fmvTdEjDirKj0=";
  };

  postPatch = ''
    # Upstream doesn't set a version for the pyproject.toml
    substituteInPlace pyproject.toml \
      --replace-fail "0.0.0" "${version}" \
      --replace-fail "--cov" ""
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    awesomeversion
    backoff
    cachetools
    mashumaro
    orjson
    yarl
  ];

  passthru.optional-dependencies = {
    cli = [
      typer
      zeroconf
    ];
  };

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [ "wled" ];

  meta = with lib; {
    description = "Asynchronous Python client for WLED";
    homepage = "https://github.com/frenck/python-wled";
    changelog = "https://github.com/frenck/python-wled/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
