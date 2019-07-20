{ stdenv, python3Packages }:

with python3Packages;
buildPythonApplication rec {
  pname = "autoflake";
  version = "1.3";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wzrvrn6279fijg8jkqbs6313f7b5ll5d22pk5s0fc1fp2wyanbb";
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
