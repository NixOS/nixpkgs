{
  lib,
  requests,
  buildPythonPackage,
  fetchPypi,
  prometheus-client,
}:

buildPythonPackage rec {
  pname = "uptime-kuma-monitor";
  version = "1.0.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "uptime_kuma_monitor";
    inherit version;
    hash = "sha256-aVoqh5MoWUYV3egn3vzHCNo++jRmHNiiJ1kVCU1BJH4=";
  };

  propagatedBuildInputs = [
    requests
    prometheus-client
  ];

  # Project has no test
  doCheck = false;

  pythonImportsCheck = [ "uptime_kuma_monitor" ];

  meta = {
    description = "Python wrapper around UptimeKuma /metrics endpoint";
    homepage = "https://github.com/meichthys/utptime_kuma_monitor";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
