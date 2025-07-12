{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  gotrue,
  postgrest-py,
  realtime,
  storage3,
  supafunc,
  httpx,
}:

buildPythonPackage rec {
  pname = "supabase";
  version = "2.16.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mPOBAVgBLU7A4wg/LlUV9eELMr1x59RYZiFA6WPB0WQ=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    postgrest-py
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
