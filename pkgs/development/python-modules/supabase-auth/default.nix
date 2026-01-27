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
buildPythonPackage rec {
  pname = "supabase-auth";
  version = "2.27.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "supabase-py";
    tag = "v${version}";
    hash = "sha256-8LppL3OTUsA7P7KssxlN/BFFqdxCK+fIhbiPxQTKNHc=";
  };

  sourceRoot = "${src.name}/src/auth";

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
      --replace-warn 'uv_build>=0.8.3,<0.9.0' 'uv_build>=0.8.3,<0.10.0'
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
    changelog = "https://github.com/supabase/supabase-py/blob/v${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ macbucheron ];
  };
}
