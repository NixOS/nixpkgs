{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  gotrue,
  postgrest,
  realtime,
  storage3,
  supafunc,
  httpx,
  pytestCheckHook,
  python-dotenv,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "supabase";
  version = "2.27.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "supabase-py";
    tag = "v${version}";
    hash = "sha256-TRATa+lDRm2MDuARXfBRWnWYUak8i1fW7rr5ujWN8TY=";
  };

  build-system = [ poetry-core ];

  # FIXME remove for supabase >= 2.18.0
  pythonRelaxDeps = true;

  dependencies = [
    postgrest
    realtime
    gotrue
    httpx
    storage3
    supafunc
  ];

  nativeBuildInputs = [
    pytestCheckHook
    python-dotenv
    pytest-asyncio
  ];

  pythonImportsCheck = [ "supabase" ];

  meta = {
    homepage = "https://github.com/supabase/supabase-py";
    license = lib.licenses.mit;
    description = "Supabas client for Python";
    maintainers = with lib.maintainers; [ siegema ];
  };
}
