{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  gotrue,
  postgrest-py,
  realtime,
  storage3,
  supafunc,
  httpx,
  pytestCheckHook,
  python-dotenv,
  pytest-asyncio,
  pydantic,
}:

buildPythonPackage rec {
  pname = "supabase";
  version = "2.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "supabase-py";
    rev = "v${version}";
    hash = "sha256-n+LVC4R9m/BKID9wLEMw/y/2I589TUXTygSIPfTZwB8=";
  };

  build-system = [ poetry-core ];

  propagatedBuildInputs = [
    postgrest-py
    realtime
    gotrue
    httpx
    storage3
    supafunc
    pydantic
  ];

  nativeBuildInputs = [
    pytestCheckHook
    python-dotenv
    pytest-asyncio
  ];

  pythonImportsCheck = [ "supabase" ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/supabase/supabase-py";
    license = lib.licenses.mit;
    description = "Supabas client for Python";
    maintainers = with lib.maintainers; [ siegema ];
  };
}
