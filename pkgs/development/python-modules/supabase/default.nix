{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  realtime,
  supabase-functions,
  supabase-auth,
  postgrest,
  httpx,
  yarl,
  storage3,
  pytestCheckHook,
  python-dotenv,
  pytest-asyncio,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "supabase";
  version = "2.28.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "supabase-py";
    tag = "v${version}";
    hash = "sha256-nK+IZRrKjNy84EC8krBvAZll5E0+jV3bLJh8qIVRElI=";
  };

  sourceRoot = "${src.name}/src/supabase";

  build-system = [ uv-build ];

  doCheck = true;

  dependencies = [
    realtime
    supabase-auth
    supabase-functions
    postgrest
    httpx
    yarl
    storage3
  ];

  nativeBuildInputs = [
    pytestCheckHook
    python-dotenv
    pytest-asyncio
    pytest-cov-stub
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'uv_build>=0.8.3,<0.9.0' 'uv_build>=0.8.3'
  '';

  pythonImportsCheck = [ "supabase" ];

  meta = {
    homepage = "https://github.com/supabase/supabase-py";
    license = lib.licenses.mit;
    description = "Supabas client for Python";
    maintainers = with lib.maintainers; [ siegema ];
  };
}
