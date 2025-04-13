{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  python-dateutil,
  httpx,
  h2,
  deprecation,
}:

buildPythonPackage rec {
  pname = "storage3";
  version = "0.12.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lCQ/IJItV3OL9C6WufVYK00WbovyCezPILFGkJ8/cbA=";
  };

  dependencies = [
    python-dateutil
    httpx
    h2
    deprecation
  ];

  nativeBuildInputs = [ poetry-core ];

  pythonImportCheck = [ "storage3" ];

  # tests aren't in pypi package
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/supabase/storage-py.git";
    license = licenses.mit;
    description = "Supabase Storage client for Python.";
    maintainers = with maintainers; [ siegema ];
  };
}
