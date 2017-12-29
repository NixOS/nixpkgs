{ stdenv, python3Packages }:

with python3Packages;
buildPythonApplication rec {
  pname = "autoflake";
  version = "1.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12k4v8w7awqp83j727y0iwcbjqj3ccvbai7c9m0wgbmq5xkvav8a";
  };

  propagatedBuildInputs = [ pyflakes ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/myint/autoflake;
    description = "A simple program which removes unused imports and unused variables as reported by pyflakes";
    license = licenses.mit;
    maintainers = with maintainers; [ yuriaisaka ];
  };
}
