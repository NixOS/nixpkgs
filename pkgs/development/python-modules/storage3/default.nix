{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
, python-dateutil
, httpx
, h2
}:

buildPythonPackage rec {
  pname = "storage3";
  version = "0.11.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-iDY3EyqtNtnZK3xJeopW3/fFHxX68v96y8zvu9Xpc0c=";
  };

  propagatedBuildInputs = [ python-dateutil httpx h2 ];

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
