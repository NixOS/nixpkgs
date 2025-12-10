{
  lib,
  python3Packages,
  fetchPypi,
  nixosTests,
}:

python3Packages.buildPythonApplication rec {
  pname = "kea-exporter";
  version = "0.7.0";
  format = "pyproject";

  src = fetchPypi {
    pname = "kea_exporter";
    inherit version;
    hash = "sha256-kn2iwYWcyW90tgfWmzLF7rU06fJyLRzqYKNLOgu/Yqk=";
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
    inherit (nixosTests) kea;
  };

  meta = {
    changelog = "https://github.com/mweinelt/kea-exporter/blob/v${version}/HISTORY";
    description = "Export Kea Metrics in the Prometheus Exposition Format";
    mainProgram = "kea-exporter";
    homepage = "https://github.com/mweinelt/kea-exporter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
