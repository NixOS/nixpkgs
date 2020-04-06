{ stdenv, python }:

with python.pkgs;

buildPythonApplication rec {
  pname = "rdbtools";
  version = "0.1.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03vdwwkqz8py6c3wfgx402rn8pjjfn44w3gbxzr60lbkx27m63yj";
  };

  propagatedBuildInputs = [ redis python-lzf ];

  # No tests in published package
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Parse Redis dump.rdb files, Analyze Memory, and Export Data to JSON";
    homepage = https://github.com/sripathikrishnan/redis-rdb-tools;
    license = licenses.mit;
    maintainers = with maintainers; [ offline ];
  };
}
