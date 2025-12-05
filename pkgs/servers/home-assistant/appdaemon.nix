{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "appdaemon";
  version = "4.5.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AppDaemon";
    repo = "appdaemon";
    rev = "refs/tags/${version}";
    hash = "sha256-lcGQQz+kPefHSyc2RNQ4gHgraRJPvn/FcgMJGvCtC48=";
  };

  pythonRelaxDeps = true;

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    aiohttp
    aiohttp-jinja2
    astral
    bcrypt
    deepdiff
    feedparser
    iso8601
    paho-mqtt
    pid
    pydantic
    python-dateutil
    python-socketio
    pytz
    pyyaml
    requests
    sockjs
    uvloop
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
    teams = [ teams.home-assistant ];
  };
}
