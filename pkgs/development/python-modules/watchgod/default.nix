{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "watchgod";
  version = "0.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0aagm0n5fkpzdsfgl0r21gkz5qaicgq3f4rqz2fdvsgbn1i0s528";
  };

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
