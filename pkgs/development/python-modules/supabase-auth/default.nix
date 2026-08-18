{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  httpx,
  pydantic,
  pyjwt,
  pytestCheckHook,
  faker,
  respx,
  pytest-mock,
  pytest-asyncio,
}:
buildPythonPackage (finalAttrs: {
  pname = "supabase-auth";
  version = "2.29.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "supabase-py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LaSlAYFvx/HHdfmc9J+KScVQ9JFGS98Yfihzn8F7t3g=";
  };

  sourceRoot = "${finalAttrs.src.name}/src/auth";

  build-system = [ uv-build ];

  dependencies = [
    httpx
    pydantic
    pyjwt
  ]
  ++ httpx.optional-dependencies.http2
  ++ pyjwt.optional-dependencies.crypto;

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'uv_build>=0.8.3,<0.9.0' 'uv_build>=0.8.3'
  '';

  nativeCheckInputs = [
    pytestCheckHook
    faker
    respx
    pytest-mock
    pytest-asyncio
  ];

  disabledTestPaths = [
    "tests/_sync/"
    "tests/_async/"
  ];

  pythonImportsCheck = [ "supabase_auth" ];

  meta = {
    description = "Client library for Supabase Auth";
    homepage = "https://github.com/supabase/supabase-py/";
    changelog = "https://github.com/supabase/supabase-py/blob/v${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ macbucheron ];
  };
})
