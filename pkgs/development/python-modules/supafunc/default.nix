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
  version = "0.9.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aIJKmnvMz1qx4DjNpjK6R8uifyp9xgYBQga1b1oHHeI=";
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
