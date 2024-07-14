{
  lib,
  buildPythonPackage,
  fetchPypi,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "treelog";
  version = "1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AcUGrXagX7i8nuBuOasheRM5csqavS6b8ZNScsnf0UI=";
  };

  pythonImportsCheck = [ "treelog" ];

  propagatedBuildInputs = [ typing-extensions ];

  meta = with lib; {
    description = "Logging framework that organizes messages in a tree structure";
    homepage = "https://github.com/evalf/treelog";
    license = licenses.mit;
    maintainers = [ maintainers.Scriptkiddi ];
  };
}
