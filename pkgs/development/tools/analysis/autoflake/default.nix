{ lib, python3Packages }:

with python3Packages;
buildPythonApplication rec {
  pname = "autoflake";
  version = "1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "61a353012cff6ab94ca062823d1fb2f692c4acda51c76ff83a8d77915fba51ea";
  };

  propagatedBuildInputs = [ pyflakes ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/myint/autoflake";
    description = "A simple program which removes unused imports and unused variables as reported by pyflakes";
    license = licenses.mit;
    maintainers = with maintainers; [ yuriaisaka ];
  };
}
