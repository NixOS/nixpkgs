{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
, strenum
, httpx
, h2
}:

buildPythonPackage rec {
  pname = "supafunc";
  version = "0.9.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-aIJKmnvMz1qx4DjNpjK6R8uifyp9xgYBQga1b1oHHeI=";
  };

  propagatedBuildInputs = [ strenum httpx h2 ];

  nativeBuildInputs = [ poetry-core ];

  pythonImportsCheck = [ "supafunc" ];

  # tests are not in pypi package
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/supabase/functions-py.git";
    license = licenses.mit;
    description = "Library for Supabase Functions";
    maintainers = with maintainers; [ siegema ];
  };
}
