{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  httpx,
  h2,
  pydantic,
  pyjwt,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "supabase_auth";
  version = "2.12.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-b5nb8yS8WHbT7nAhNe5O9iLtfwjI61HfHZzmleqfhGA=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    httpx
    h2
    pydantic
    pyjwt
    pytest-mock
  ];

  pythonImportsCheck = [ "supabase_auth" ];

  # test aren't in pypi package
  doCheck = false;

  meta = {
    homepage = "https://github.com/supabase/auth-py";
    license = lib.licenses.mit;
    description = "Python Client Library for Supabase Auth";
    maintainers = with lib.maintainers; [ siegema ];
  };
}
