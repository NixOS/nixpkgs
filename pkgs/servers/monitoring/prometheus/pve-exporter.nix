{ lib
, python3
, fetchPypi
, nixosTests
}:

python3.pkgs.buildPythonApplication rec {
  pname = "prometheus-pve-exporter";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-hL1+vP+/Xi3od+17906YARgg4APlFhRkdOCnRxDHJmM=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    prometheus-client
    proxmoxer
    pyyaml
    requests
    werkzeug
    gunicorn
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
