{ lib , python, buildPythonPackage , fetchPypi, typing-extensions }:

buildPythonPackage rec {
  pname = "treelog";
  version = "1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hnivz4p4llky6djxgcsr9r3j4vr46mkjvp0ksybhpx0fsnhdi81";
  };

  pythonImportsCheck = [ "treelog" ];

  propagatedBuildInputs = [
    typing-extensions
  ];

  checkPhase = ''
    ${python.interpreter} -m unittest
  '';

  meta = with lib; {
    description = "Logging framework that organizes messages in a tree structure";
    homepage = "https://github.com/evalf/treelog";
    license = licenses.mit;
    maintainers = [ maintainers.Scriptkiddi ];
  };
}
