{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "appdaemon";
  version = "4.4.2";
  pyproject = true;

  disabled = python3.pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "AppDaemon";
    repo = "appdaemon";
    rev = "refs/tags/${version}";
    hash = "sha256-T3InE4J4qYeFJTq6nrW8y5BOA7Z0n3t9eVpl641r/xk=";
  };

  postPatch = ''
    # relax dependencies
    sed -i 's/~=/>=/' pyproject.toml
  '';

  nativeBuildInputs = with python3.pkgs; [
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
    homepage = "https://github.com/AppDaemon/appdaemon";
    changelog = "https://github.com/AppDaemon/appdaemon/blob/${version}/docs/HISTORY.md";
    license = licenses.mit;
    maintainers = teams.home-assistant.members;
  };
}
