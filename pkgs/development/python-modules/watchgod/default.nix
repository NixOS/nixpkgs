{ lib
, buildPythonPackage
, fetchPypi
, anyio
}:

buildPythonPackage rec {
  pname = "watchgod";
  version = "0.8.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yxH/ZmV777qU2CjjtiLV+3byL72hN281Xz5uUel9lFA=";
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
