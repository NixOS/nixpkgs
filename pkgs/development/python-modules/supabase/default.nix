{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  gotrue,
  postgrest,
  realtime,
  storage3,
  supafunc,
  httpx,
}:

buildPythonPackage rec {
  pname = "supabase";
  version = "2.15.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LmYomtdK6cTLBKafneAM0s6IDNiQ3iMmmkCsW2kVHSY=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    postgrest
    realtime
    gotrue
    httpx
    storage3
    supafunc
  ];

  pythonImportsCheck = [ "supabase" ];

  # test aren't in pypi package
  doCheck = false;

  meta = {
    homepage = "https://github.com/supabase-community/supabase-py";
    license = lib.licenses.mit;
    description = "Supabas client for Python";
    maintainers = with lib.maintainers; [ siegema ];
  };
}
