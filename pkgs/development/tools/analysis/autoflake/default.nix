{ stdenv, python3Packages }:

with python3Packages;
buildPythonApplication rec {
  pname = "autoflake";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0nzr057dbmgprp4a52ymafdkdd5zp2wcqf42913xc7hhvvdbj338";
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
