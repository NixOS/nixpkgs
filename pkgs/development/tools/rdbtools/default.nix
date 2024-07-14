{ lib, python, fetchPypi }:

with python.pkgs;

buildPythonApplication rec {
  pname = "rdbtools";
  version = "0.1.15";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aJ5X5C9Dvcc+pOiT2WdoGZgNF5aGloJrafvZUfWXct4=";
  };

  propagatedBuildInputs = [ redis python-lzf ];

  # No tests in published package
  doCheck = false;

  meta = with lib; {
    description = "Parse Redis dump.rdb files, Analyze Memory, and Export Data to JSON";
    homepage = "https://github.com/sripathikrishnan/redis-rdb-tools";
    license = licenses.mit;
    maintainers = with maintainers; [ offline ];
  };
}
