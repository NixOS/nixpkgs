{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  asttokens,
  executing,
  pure-eval,
}:

buildPythonPackage rec {
  pname = "varname";
  version = "0.14.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NThGd+CDICpgqO0Y/zNgIOXQF8+NwWkdCUhVOcRao4s=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "poetry.masonry.api" "poetry.core.masonry.api"
  '';

  build-system = [ poetry-core ];

  dependencies = [
    asttokens
    executing
    pure-eval
  ];

  pythonImportsCheck = [ "varname" ];

  meta = {
    description = "Reactive logging";
    homepage = "https://github.com/pwwang/python-varname";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
