{ lib
, buildPythonApplication
, fetchPypi
}:

buildPythonApplication rec {
  pname = "pwncat";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0sfdqphs0v3lj3vffda4w05r6sqir7qafa8lmlh0wr921wyiqwag";
  };

  # Tests requires to start containers
  doCheck = false;

  meta = with lib; {
    description = " TCP/UDP communication suite";
    homepage = "https://pwncat.org/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
