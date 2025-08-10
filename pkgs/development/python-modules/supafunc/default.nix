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
  version = "0.10.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ReTVAIVBZ8JhUVxD96NjMg4KkoEYGC/okyre/d7dtUU=";
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
