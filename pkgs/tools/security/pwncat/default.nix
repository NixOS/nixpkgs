{
  lib,
  buildPythonApplication,
  fetchPypi,
}:

buildPythonApplication rec {
  pname = "pwncat";
  version = "0.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1230fdn5mx3wwr3a3nn6z2vwh973n248m11hnx9y3fjq7bgpky67";
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
