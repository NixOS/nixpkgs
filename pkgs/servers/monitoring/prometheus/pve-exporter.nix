{
  lib,
  python3,
  fetchPypi,
  nixosTests,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "prometheus_pve_exporter";
  version = "3.8.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tTEuyLKGIG0uvOMLnpT31YNkOeGM82lzFHwHjLfnOj0=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    prometheus-client
    proxmoxer
    pyyaml
    requests
    werkzeug
    gunicorn
    wrapt
  ];

  doCheck = false;

  pythonImportsCheck = [ "pve_exporter" ];

  passthru.tests = {
    inherit (nixosTests.prometheus-exporters) pve;
  };

  meta = {
    description = "Exposes information gathered from Proxmox VE cluster for use by the Prometheus monitoring system";
    mainProgram = "pve_exporter";
    homepage = "https://github.com/prometheus-pve/prometheus-pve-exporter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nukaduka ];
  };
}
