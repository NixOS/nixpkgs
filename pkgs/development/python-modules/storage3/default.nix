{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  uv-build,
  httpx,
  pydantic,
  yarl,
  pyiceberg,
  deprecation,
  pytest-asyncio,
  pytest-cov-stub,
  python-dotenv,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "storage3";
  version = "2.28.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "supabase-py";
    tag = "v${version}";
    hash = "sha256-Ra7Ig9IMWouMIadx6mg/pe8GlgLCavR6OsPjqgySTCw=";
  };

  sourceRoot = "${src.name}/src/storage";

  build-system = [ uv-build ];

  dependencies = [
    httpx
    pydantic
    yarl
    pyiceberg
    deprecation
  ]
  ++ httpx.optional-dependencies.http2;

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'uv_build>=0.8.3,<0.9.0' 'uv_build>=0.8.3'
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-cov-stub
    python-dotenv
  ];

  pythonImportsCheck = [ "storage3" ];

  disabledTestPaths = [
    "tests/_sync/"
    "tests/_async/"
  ];

  meta = {
    description = "Client library for Supabase Functions";
    homepage = "https://github.com/supabase/supabase-py";
    changelog = "https://github.com/supabase/supabase-py/blob/v${src.tag}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ siegema ];
    license = lib.licenses.mit;
  };
}
