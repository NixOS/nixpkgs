<<<<<<< HEAD
{ lib, python3Packages, fetchPypi, nixosTests }:
=======
{ lib, python3Packages, nixosTests }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

python3Packages.buildPythonApplication rec {
  pname = "kea-exporter";
  version = "0.5.1";
  format = "pyproject";

<<<<<<< HEAD
  src = fetchPypi {
=======
  src = python3Packages.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
