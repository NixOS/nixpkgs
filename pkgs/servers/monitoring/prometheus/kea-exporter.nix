{ lib, python3Packages, nixosTests }:

python3Packages.buildPythonApplication rec {
  pname = "kea-exporter";
  version = "0.4.4";
  format = "pyproject";

  src = python3Packages.fetchPypi {
    inherit pname version;
    hash = "sha256-8hWQfI9HCSKhkgN3F0mwvKKJg6FlwqRZ1QuQFB1YXrc=";
  };

  nativeBuildInputs = with python3Packages; [
    poetry-core
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

