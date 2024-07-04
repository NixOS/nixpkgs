{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "appdaemon";
  version = "4.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AppDaemon";
    repo = "appdaemon";
    rev = "refs/tags/${version}";
    hash = "sha256-T3InE4J4qYeFJTq6nrW8y5BOA7Z0n3t9eVpl641r/xk=";
  };

  pythonRelaxDeps = true;

  nativeBuildInputs = with python3.pkgs; [
    pythonRelaxDepsHook
    setuptools
  ];

  propagatedBuildInputs = with python3.pkgs; [
    aiohttp
    aiohttp-jinja2
    astral
    bcrypt
    deepdiff
    feedparser
    iso8601
    paho-mqtt
    pid
    python-dateutil
    python-socketio
    pytz
    pyyaml
    requests
    sockjs
    uvloop
    websocket-client
    tomli
    tomli-w
  ];

  # no tests implemented
  checkPhase = ''
    $out/bin/appdaemon -v | grep -q "${version}"
  '';

  meta = with lib; {
    description = "Sandboxed Python execution environment for writing automation apps for Home Assistant";
    mainProgram = "appdaemon";
    homepage = "https://github.com/AppDaemon/appdaemon";
    changelog = "https://github.com/AppDaemon/appdaemon/blob/${version}/docs/HISTORY.md";
    license = licenses.mit;
    maintainers = teams.home-assistant.members;
  };
}
