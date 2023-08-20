{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "faraday-agent-dispatcher";
  version = "2.6.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "infobyte";
    repo = "faraday_agent_dispatcher";
    rev = "refs/tags/${version}";
    hash = "sha256-+lsejepg/iBHo6CRAGNHjiUC7ZgboHbKu7EDmlN3lVk=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner",' ""
  '';

  nativeBuildInputs = with python3.pkgs; [
    setuptools-scm
  ];

  propagatedBuildInputs = with python3.pkgs; [
    aiohttp
    click
    faraday-agent-parameters-types
    faraday-plugins
    itsdangerous
    psutil
    pytenable
    python-gvm
    python-owasp-zap-v2-4
    pyyaml
    requests
    syslog-rfc5424-formatter
    websockets
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytest-asyncio
    pytestCheckHook
  ];

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
    changelog = "https://github.com/infobyte/faraday_agent_dispatcher/releases/tag/${version}";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
