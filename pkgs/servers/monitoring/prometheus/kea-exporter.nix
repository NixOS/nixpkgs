{ lib, python3Packages, fetchPypi, nixosTests }:

python3Packages.buildPythonApplication rec {
  pname = "kea-exporter";
  version = "0.5.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rNGA5XEx9xVUP1SeDPgXcaqgDhgX6JFhRX9GM454P5A=";
  };

  nativeBuildInputs = with python3Packages; [
    pdm-pep517
  ];

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
