{
  lib,
  python3,
  fetchPypi,
  nixosTests,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "prometheus_pve_exporter";
  version = "3.4.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AxjtVgow1aV0vSuSre6s9c7Ru2/U6Q6knmq7B05YCnM=";
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
    mainProgram = "pve_exporter";
    homepage = "https://github.com/prometheus-pve/prometheus-pve-exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ nukaduka ];
  };
}
