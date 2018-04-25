{ stdenv, python3Packages }:

with python3Packages;
buildPythonApplication rec {
  pname = "autoflake";
  version = "1.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a74d684a7a02654f74582addc24a3016c06809316cc140457a4fe93a1e6ed131";
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
