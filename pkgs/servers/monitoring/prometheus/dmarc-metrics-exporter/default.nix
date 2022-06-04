{ lib
, python3
, fetchpatch
}:

python3.pkgs.buildPythonApplication rec {
  pname = "dmarc-metrics-exporter";
  version = "0.5.1";

  disabled = python3.pythonOlder "3.7";

  format = "pyproject";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "22ec361f9a4c86abefbfab541f588597e21bf4fbedf2911f230e560b2ec3503a";
  };

  patches = [
    # https://github.com/jgosmann/dmarc-metrics-exporter/pull/23
    (fetchpatch {
      url = "https://github.com/jgosmann/dmarc-metrics-exporter/commit/3fe401f5dfb9e0304601a2a89ac987ff853b7cba.patch";
      hash = "sha256-MjVLlFQMp2r3AhBMu1lEmRm0Y2H9FdvCfPgAK5kvwWE=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'python = "^3.7,<3.10"' 'python = "^3.7,<3.11"' \
      --replace poetry.masonry.api poetry.core.masonry.api \
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
  ];

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
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ma27 ];
  };
}
