{ lib
, fetchPypi
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mitm6";
  version = "0.3.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-g+eFcJdgP7CQ6ntN17guJa4LdkGIb91mr/NKRPIukP8=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    scapy
    future
    twisted
    netifaces
  ];

  # No tests exist for mitm6.
  doCheck = false;

  pythonImportsCheck = [
    "mitm6"
  ];

  meta = {
    description = "DHCPv6 network spoofing application";
    mainProgram = "mitm6";
    homepage = "https://github.com/dirkjanm/mitm6";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ ];
  };
}
