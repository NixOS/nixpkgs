{ stdenv
, buildPythonPackage
, python
, fetchPypi
, paramiko
}:

buildPythonPackage rec {
  pname = "sshtunnel";
  version = "0.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0xhdqj8ych976xi847k4m7llnvlnwbn9n0iik97adbyk3cdf96pj";
  };

  buildInputs = [
    paramiko
  ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "SSH tunnels to remote server";
    license = licenses.mit;
    maintainers = with maintainers; [ kuznero ];
    homepage = https://github.com/pahaz/sshtunnel;
  };
}
