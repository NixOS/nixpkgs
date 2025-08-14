{
  lib,
  buildPythonPackage,
  fetchPypi,
  httpx,
  poetry-core,
  strenum,
}:

buildPythonPackage rec {
  pname = "supafunc";
  version = "0.10.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ReTVAIVBZ8JhUVxD96NjMg4KkoEYGC/okyre/d7dtUU=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    strenum
    httpx
  ]
  ++ httpx.optional-dependencies.http2;

  # Tests are not in PyPI package and source is not tagged
  doCheck = false;

  pythonImportsCheck = [ "supafunc" ];

  meta = {
    description = "Library for Supabase Functions";
    homepage = "https://github.com/supabase/functions-py";
    changelog = "https://github.com/supabase/functions-py/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ siegema ];
  };
}
