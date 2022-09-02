{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "faraday-agent-dispatcher";
  version = "2.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "infobyte";
    repo = "faraday_agent_dispatcher";
    rev = "refs/tags/${version}";
    hash = "sha256-dTXTR2H37FDfnpY4Ts6NoYAnJX52yqRZeD2Yf8S/kS8=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools-scm
  ];

  propagatedBuildInputs = with python3.pkgs; [
    aiohttp
    click
    faraday-agent-parameters-types
    faraday-plugins
    itsdangerous
    python-gvm
    python-owasp-zap-v2-4
    pyyaml
    requests
    syslog-rfc5424-formatter
    websockets
  ];

  checkInputs = with python3.pkgs; [
    pytest-asyncio
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner",' ""
  '';

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  disabledTests = [
    "test_execute_agent"
    "SSL"
  ];

  disabledTestPaths = [
    # Tests require a running Docker instance
    "tests/plugins-docker/test_executors.py"
  ];

  pythonImportsCheck = [
    "faraday_agent_dispatcher"
  ];

  meta = with lib; {
    description = "Tool to send result from tools to the Faraday Platform";
    homepage = "https://github.com/infobyte/faraday_agent_dispatcher";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
