{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  python-dateutil,
  httpx,
  h2,
}:

buildPythonPackage rec {
  pname = "storage3";
  version = "0.11.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iDY3EyqtNtnZK3xJeopW3/fFHxX68v96y8zvu9Xpc0c=";
  };

  dependencies = [
    python-dateutil
    httpx
    h2
  ];

  build-system = [ poetry-core ];

  pythonImportCheck = [ "storage3" ];

  # tests aren't in pypi package
  doCheck = false;

  meta = {
    homepage = "https://github.com/supabase/storage-py";
    license = lib.licenses.mit;
    description = "Supabase Storage client for Python.";
    maintainers = with lib.maintainers; [ siegema ];
  };
}
