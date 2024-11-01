{
  lib,
  pythonPackages,
  executing,
  setuptools-scm,
}:

pythonPackages.buildPythonPackage rec {
  pname = "varname";
  version = "0.13.0";
  name = "${pname}-${version}";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    hash = "sha256-ZOkFICn9TUloasZEOp7RgsLBSWhuQqzvaeuqOieBG+s=";
  };

  propagatedBuildInputs = with pythonPackages; [
    setuptools-scm
    executing
  ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/pwwang/python-varname";
    description = "Dark magics about variable names in python.";
    license = licenses.mit;
  };
}
