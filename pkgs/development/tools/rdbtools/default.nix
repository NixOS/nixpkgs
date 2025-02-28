{
  lib,
  python,
  fetchPypi,
}:

with python.pkgs;

buildPythonApplication rec {
  pname = "rdbtools";
  version = "0.1.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "689e57e42f43bdc73ea4e893d9676819980d17968696826b69fbd951f59772de";
  };

  propagatedBuildInputs = [
    redis
    python-lzf
  ];

  # No tests in published package
  doCheck = false;

  meta = with lib; {
    description = "Parse Redis dump.rdb files, Analyze Memory, and Export Data to JSON";
    homepage = "https://github.com/sripathikrishnan/redis-rdb-tools";
    license = licenses.mit;
    maintainers = with maintainers; [ offline ];
  };
}
