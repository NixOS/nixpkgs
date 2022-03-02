{ lib
, python3
, nixosTests
}:

python3.pkgs.buildPythonApplication rec {
  pname = "prometheus-pve-exporter";
  version = "2.2.2";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "0vvsiw8nj8zkx6v42f260xbsdd92l0ac4vwpm7w38j3qwvanar7k";
  };

  propagatedBuildInputs = with python3.pkgs; [
    prometheus-client
    proxmoxer
    pyyaml
    requests
    werkzeug
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
