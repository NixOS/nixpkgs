{ lib, buildPythonPackage, fetchPypi, diff-match-patch }:

buildPythonPackage rec {
  pname = "three-merge";
  version = "0.1.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0w6rv7rv1zm901wbjkmm6d3vkwyf3csja9p37bb60mar8khszxk0";
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
