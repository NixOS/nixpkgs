{ stdenv
, buildPythonPackage
, fetchPypi
, pythonPackages
, setuptools
, paramiko
}:

buildPythonPackage rec {
  pname = "scp";
  version = "0.10.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18f59e48df67fac0b069591609a0f4d50d781a101ddb8ec705f0c2e3501a8386";
  };


  buildInputs = [
    paramiko
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/jbardin/scp.py;
    description = "scp module for paramiko";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ xnaveira ];
  };
}
