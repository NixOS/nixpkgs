{ lib
, buildPythonPackage
, fetchPypi
, python
}:

buildPythonPackage rec {
  pname = "untokenize";
  version = "0.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3865dbbbb8efb4bb5eaa72f1be7f3e0be00ea8b7f125c69cbd1f5fda926f37a2";
  };

  checkPhase = "${python.interpreter} -m unittest discover";

  meta = with lib; {
    description = "Transforms tokens into original source code while preserving whitespace";
    homepage = "https://github.com/myint/untokenize";
    license = licenses.mit;
    maintainers = with maintainers; [ FlorianFranzen ];
  };
}
