{ lib
, python3
<<<<<<< HEAD
, fetchPypi
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, nixosTests
}:

python3.pkgs.buildPythonApplication rec {
  pname = "prometheus-pve-exporter";
<<<<<<< HEAD
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-hL1+vP+/Xi3od+17906YARgg4APlFhRkdOCnRxDHJmM=";
=======
  version = "2.2.2";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "0vvsiw8nj8zkx6v42f260xbsdd92l0ac4vwpm7w38j3qwvanar7k";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = with python3.pkgs; [
    prometheus-client
    proxmoxer
    pyyaml
    requests
    werkzeug
<<<<<<< HEAD
    gunicorn
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  doCheck = false;

  pythonImportsCheck = [ "pve_exporter" ];

  passthru.tests = {
    inherit (nixosTests.prometheus-exporters) pve;
  };

  meta = with lib; {
    description = "Exposes information gathered from Proxmox VE cluster for use by the Prometheus monitoring system";
    homepage = "https://github.com/prometheus-pve/prometheus-pve-exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ nukaduka ];
  };
}
