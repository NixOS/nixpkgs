{ lib
, buildPythonApplication
, fetchPypi
}:

buildPythonApplication rec {
  pname = "pwncat";
  version = "0.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "62e625e9061f037cfca7b7455a4f7db4213c1d1302e73d4c475c63f924f1805f";
  };

  # Tests requires to start containers
  doCheck = false;

  meta = with lib; {
    description = "TCP/UDP communication suite";
    homepage = "https://pwncat.org/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
