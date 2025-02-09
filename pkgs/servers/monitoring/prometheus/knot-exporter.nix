{ lib
, python3
, fetchPypi
, nixosTests
}:

python3.pkgs.buildPythonApplication rec {
  pname = "knot-exporter";
  version = "3.3.2";
  pyproject = true;

  src = fetchPypi {
    pname = "knot_exporter";
    inherit version;
    hash = "sha256-/TBzq9MhYb664TsSD46Ep7gOkLBmmPSK9d89xlgvbSw=";
  };

  nativeBuildInputs = [
    python3.pkgs.hatchling
  ];

  propagatedBuildInputs = with python3.pkgs; [
    libknot
    prometheus-client
    psutil
  ];

  pythonImportsCheck = [
    "knot_exporter"
  ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) knot; };

  meta = with lib; {
    description = "Prometheus exporter for Knot DNS";
    homepage = "https://gitlab.nic.cz/knot/knot-dns/-/tree/master/python/knot_exporter";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ma27 hexa ];
    mainProgram = "knot-exporter";
  };
}
