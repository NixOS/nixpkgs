{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
, asttokens
, executing
, pure-eval
}:

buildPythonPackage rec {
  pname = "varname";
  version = "0.8.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Bvj6bn2wqYl62l4JbquV+cLjgR5p56KfdHUX5Dd/PSs=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "poetry.masonry.api" "poetry.core.masonry.api"
  '';

  buildInputs = [ poetry-core ];
  propagatedBuildInputs = [
    asttokens
    executing
    pure-eval
  ];

  pythonImportsCheck = [ "varname" ];

  meta = with lib; {
    description = "Reactive logging";
    homepage = "https://github.com/pwwang/python-varname";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
