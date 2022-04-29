{ lib
, buildPythonPackage
, fetchPypi
, anyio
}:

buildPythonPackage rec {
  pname = "watchgod";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-wS0V8999EedAcE5FOYJ3918dePRq1Zyp11Bb/YuNMIY=";
  };

  propagatedBuildInputs = [
    anyio
  ];

  # no tests in release
  doCheck = false;

  pythonImportsCheck = [ "watchgod" ];

  meta = with lib; {
    description = "Simple, modern file watching and code reload in python";
    homepage = "https://github.com/samuelcolvin/watchgod";
    license = licenses.mit;
    maintainers = with maintainers; [ globin ];
  };

}
