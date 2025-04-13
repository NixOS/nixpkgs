{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  strenum,
  httpx,
  h2,
}:

buildPythonPackage rec {
  pname = "supafunc";
  version = "0.10.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pbM8i67La1KX0l2imiUD4uxn7mmG89RME35lG4pZoX0=";
  };

  dependencies = [
    strenum
    httpx
    h2
  ];

  build-system = [ poetry-core ];

  pythonImportsCheck = [ "supafunc" ];

  # tests are not in pypi package
  doCheck = false;

  meta = {
    homepage = "https://github.com/supabase/functions-py";
    license = lib.licenses.mit;
    description = "Library for Supabase Functions";
    maintainers = with lib.maintainers; [ siegema ];
  };
}
