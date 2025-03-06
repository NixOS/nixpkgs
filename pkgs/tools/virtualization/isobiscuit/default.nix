{ lib, buildPythonPackage, fetchPypi, python3Packages }:

buildPythonPackage rec {
  pname = "isobiscuit";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mjd2zks63d16hdcpj1dn85p44vx9xd8b4zyalgzbn0nj82223wn";
  };

  propagatedBuildInputs = with python3Packages; [
    requests
    grpcio
    grpcio-tools
    pyyaml
    colorama
    poetry-core

  ];

  meta = with lib; {
    description = "IsoBiscuit is a tool for virtualization, where processes are running in biscuits.";
    license = licenses.asl20;
    maintainers = with maintainers; [ TrollMii ];
  };
}
