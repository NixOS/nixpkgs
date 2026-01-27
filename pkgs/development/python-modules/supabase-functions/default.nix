{
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  lib,
  pyjwt,
  pytest-asyncio,
  pytestCheckHook,
  pytest-cov,
  strenum,
  uv-build,
  yarl,
}:

buildPythonPackage rec {
  pname = "supabase-functions";
  version = "2.27.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "supabase-py";
    tag = "v${version}";
    hash = "sha256-8LppL3OTUsA7P7KssxlN/BFFqdxCK+fIhbiPxQTKNHc=";
  };

  sourceRoot = "${src.name}/src/functions";

  build-system = [ uv-build ];

  dependencies = [
    strenum
    yarl
    httpx
  ]
  ++ httpx.optional-dependencies.http2;

  # Upstream pins `uv_build>=0.8.3,<0.9.0`, but nixpkgs ships `uv-build` 0.9.x.
  # Relax the upper bound to accept the 0.9 series, consistent with uv’s documentation examples:
  # https://docs.astral.sh/uv/concepts/build-backend/#using-the-uv-build-backend
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-warn 'uv_build>=0.8.3,<0.9.0' 'uv_build>=0.8.3,<0.10.0'
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pyjwt
    pytest-asyncio
  ];

  pythonImportsCheck = [ "supabase_functions" ];

  meta = {
    description = "Client library for Supabase Functions";
    homepage = "https://github.com/supabase/supabase-py";
    changelog = "https://github.com/supabase/supabase-py/blob/v${src.tag}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ macbucheron ];
    license = lib.licenses.mit;
  };
}
