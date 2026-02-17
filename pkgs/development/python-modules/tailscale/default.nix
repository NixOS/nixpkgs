{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  orjson,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  yarl,
}:

buildPythonPackage rec {
  pname = "tailscale";
  version = "0.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-tailscale";
    tag = "v${version}";
    hash = "sha256-azqvMAluhThfteLEZObApnJjtnT3NzO+VVwTzmxuaFY=";
  };

  postPatch = ''
    # Upstream doesn't set a version for the pyproject.toml
    substituteInPlace pyproject.toml \
      --replace 'version = "0.0.0"' 'version = "${version}"'
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    mashumaro
    orjson
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "tailscale" ];

  meta = {
    description = "Python client for the Tailscale API";
    homepage = "https://github.com/frenck/python-tailscale";
    changelog = "https://github.com/frenck/python-tailscale/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
