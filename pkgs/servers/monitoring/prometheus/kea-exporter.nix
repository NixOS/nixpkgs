{ lib, python3Packages, nixosTests }:

python3Packages.buildPythonApplication rec {
  pname = "kea-exporter";
  version = "0.4.2";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "0dpzicv0ksyda2lprldkj452c23qycl5c9avca6x7f7rbqry9pnd";
  };

  propagatedBuildInputs = with python3Packages; [
    click
    prometheus-client
  ];

  checkPhase = ''
    $out/bin/kea-exporter --help > /dev/null
    $out/bin/kea-exporter --version | grep -q ${version}
  '';

  passthru.tests = {
    inherit (nixosTests.prometheus-exporters) kea;
  };

  meta = with lib; {
    description = "Export Kea Metrics in the Prometheus Exposition Format";
    homepage = "https://github.com/mweinelt/kea-exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}

