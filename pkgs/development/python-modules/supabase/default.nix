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
  version = "2.17.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "supabase-py";
    rev = "v${version}";
    hash = "sha256-psfDs5BCtUjyPsfLwksNvzLmUKmYDvmxKIDPQE/NmQU=";
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
