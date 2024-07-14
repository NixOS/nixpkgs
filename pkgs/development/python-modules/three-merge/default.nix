{
  lib,
  buildPythonPackage,
  fetchPypi,
  diff-match-patch,
}:

buildPythonPackage rec {
  pname = "three-merge";
  version = "0.1.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YPav4URZVWDWOuMmJTUbzvO5RzO1Trl4AKn+sPPZ2XA=";
  };

  propagatedBuildInputs = [ diff-match-patch ];

  dontUseSetuptoolsCheck = true;

  pythonImportsCheck = [ "three_merge" ];

  meta = with lib; {
    description = "Simple library for merging two strings with respect to a base one";
    homepage = "https://github.com/spyder-ide/three-merge";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
