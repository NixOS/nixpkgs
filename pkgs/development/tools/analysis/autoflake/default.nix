{ stdenv, python3Packages }:

with python3Packages;
buildPythonApplication rec {
  pname = "autoflake";
  version = "1.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c103e63466f11db3617167a2c68ff6a0cda35b940222920631c6eeec6b67e807";
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
