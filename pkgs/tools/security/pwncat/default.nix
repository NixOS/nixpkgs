{ lib
, buildPythonApplication
, fetchPypi
}:

buildPythonApplication rec {
  pname = "pwncat";
  version = "0.1.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-x/h53zpYuuFTtzCEioiw4yTIt/jG2qFG5nz0WmxzYIg=";
  };

  # Tests requires to start containers
  doCheck = false;

  meta = with lib; {
    description = "TCP/UDP communication suite";
    mainProgram = "pwncat";
    homepage = "https://pwncat.org/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
