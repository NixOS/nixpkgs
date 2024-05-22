{
  lib,
  aiohttp,
  aresponses,
  awesomeversion,
  backoff,
  buildPythonPackage,
  cachetools,
  fetchFromGitHub,
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
  version = "0.18.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-wled";
    rev = "refs/tags/v${version}";
    hash = "sha256-0BJgbyDhCPFlHxlEry7Rh/j0nv3D3kRhIqCSW+Irhqk=";
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
