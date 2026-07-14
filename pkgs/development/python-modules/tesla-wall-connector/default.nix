{
  lib,
  aiohttp,
  aresponses,
  backoff,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  uv-build,
}:

buildPythonPackage rec {
  pname = "tesla-wall-connector";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "einarhauks";
    repo = "tesla-wall-connector";
    tag = version;
    hash = "sha256-CQG4upa+DTuRIvnJ7dPy7ANELks8TrlWNOWMylXJPr4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.11.6,<0.12" "uv_build"
  '';

  build-system = [ uv-build ];

  dependencies = [
    aiohttp
    backoff
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "tesla_wall_connector" ];

  meta = {
    description = "Library for communicating with a Tesla Wall Connector";
    homepage = "https://github.com/einarhauks/tesla-wall-connector";
    changelog = "https://github.com/einarhauks/tesla-wall-connector/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
