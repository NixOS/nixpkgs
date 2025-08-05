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
    sha256 = "0zi4856hj5ar4yidh7366kx3xnh8qzydw9z8vlalcn98jf3jlnk9";
  };

  propagatedBuildInputs = [
    requests
    prometheus-client
  ];

  # Project has no test
  doCheck = false;

  pythonImportsCheck = [ "uptime_kuma_monitor" ];

  meta = with lib; {
    description = "Python wrapper around UptimeKuma /metrics endpoint";
    homepage = "https://github.com/meichthys/utptime_kuma_monitor";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
