{ lib
, python3Packages
, fetchPypi
, nixosTests
}:

python3Packages.buildPythonApplication rec {
  pname = "kea-exporter";
  version = "0.6.1";
  format = "pyproject";

  src = fetchPypi {
    pname = "kea_exporter";
    inherit version;
    hash = "sha256-PyNFSTDqT+PBY7d9NSG1FVhN+Y3ID13T6859kBYsFzU=";
  };

  nativeBuildInputs = with python3Packages; [
    pdm-backend
  ];

  propagatedBuildInputs = with python3Packages; [
    click
    prometheus-client
    requests
  ];

  checkPhase = ''
    $out/bin/kea-exporter --help > /dev/null
    $out/bin/kea-exporter --version | grep -q ${version}
  '';

  passthru.tests = {
    inherit (nixosTests.prometheus-exporters) kea;
  };

  meta = with lib; {
    changelog = "https://github.com/mweinelt/kea-exporter/blob/v${version}/HISTORY";
    description = "Export Kea Metrics in the Prometheus Exposition Format";
    mainProgram = "kea-exporter";
    homepage = "https://github.com/mweinelt/kea-exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
