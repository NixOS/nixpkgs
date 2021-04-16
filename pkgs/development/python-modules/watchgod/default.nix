{ lib, fetchPypi, buildPythonPackage, }:

buildPythonPackage rec {
  pname = "watchgod";
  version = "0.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-SBQNYrDr6d2c+DgTN/BjUeHy5wsiA/qcbv9OVyyoTyk=";
  };

  pythonImportsCheck = [ "watchgod" ];

  meta = with lib; {
    description = "Simple, modern file watching and code reload in python";
    homepage = "https://github.com/samuelcolvin/watchgod";
    license = licenses.mit;
    maintainers = with maintainers; [ vojta001 ];
  };
}
