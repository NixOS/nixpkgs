{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "dmarc-metrics-exporter";
  version = "1.1.0";

  disabled = python3.pythonOlder "3.8";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "jgosmann";
    repo = "dmarc-metrics-exporter";
    rev = "refs/tags/v${version}";
    hash = "sha256-xzIYlOZ1HeW+jbVDVlUPTIooFraQ0cJltsDoCzVMNsA=";
  };

  pythonRelaxDeps = true;

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    bite-parser
    dataclasses-serialization
    prometheus-client
    structlog
    uvicorn
    xsdata
  ]
  ++ uvicorn.optional-dependencies.standard;

  nativeCheckInputs = with python3.pkgs; [
    aiohttp
    pytest-asyncio
    pytestCheckHook
    requests
  ];

  disabledTestPaths = [
    # require networking
    "dmarc_metrics_exporter/tests/test_e2e.py"
    "dmarc_metrics_exporter/tests/test_imap_client.py"
    "dmarc_metrics_exporter/tests/test_imap_queue.py"
  ];

  pythonImportsCheck = [ "dmarc_metrics_exporter" ];

  meta = {
    description = "Export Prometheus metrics from DMARC reports";
    mainProgram = "dmarc-metrics-exporter";
    homepage = "https://github.com/jgosmann/dmarc-metrics-exporter";
    changelog = "https://github.com/jgosmann/dmarc-metrics-exporter/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ma27 ];
  };
}
