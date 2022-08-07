{ lib
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "dmarc-metrics-exporter";
  version = "0.6.1";

  disabled = python3.pythonOlder "3.7";

  format = "pyproject";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    hash = "sha256-VYmSHDde3zLq7NcsX7xp1JYe6x6RKFEravpakIzW390=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'uvicorn = {extras = ["standard"], version = "^0.15.0"}' 'uvicorn = {version = "^0.15.0"}' \
      --replace '"^' '">='
  '';

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    bite-parser
    dataclasses-serialization
    prometheus-client
    typing-extensions
    uvicorn
    xsdata
  ]
  ++ uvicorn.optional-dependencies.standard;

  checkInputs = with python3.pkgs; [
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
    homepage = "https://github.com/jgosmann/dmarc-metrics-exporter";
    changelog = "https://github.com/jgosmann/dmarc-metrics-exporter/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ma27 ];
  };
}
