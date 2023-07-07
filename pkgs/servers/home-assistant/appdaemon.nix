{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "appdaemon";
  version = "4.2.1";
  format = "setuptools";

  disabled = python3.pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "AppDaemon";
    repo = "appdaemon";
    rev = "refs/tags/${version}";
    hash = "sha256-4sN0optkMmyWb5Cd3F7AhcXYHh7aidJE/bieYMEKgSY=";
  };

  postPatch = ''
    # relax dependencies
    sed -i 's/==/>=/' requirements.txt
  '';

  propagatedBuildInputs = with python3.pkgs; [
    aiodns
    aiohttp
    aiohttp-jinja2
    astral
    azure-keyvault-secrets
    azure-mgmt-compute
    azure-mgmt-resource
    azure-mgmt-storage
    azure-storage-blob
    bcrypt
    faust-cchardet
    deepdiff
    feedparser
    iso8601
    jinja2
    paho-mqtt
    pid
    pygments
    python-dateutil
    python-engineio
    python-socketio
    pytz
    pyyaml
    requests
    sockjs
    uvloop
    voluptuous
    websocket-client
    yarl
  ];

  # no tests implemented
  checkPhase = ''
    $out/bin/appdaemon -v | grep -q "${version}"
  '';

  meta = with lib; {
    description = "Sandboxed Python execution environment for writing automation apps for Home Assistant";
    homepage = "https://github.com/AppDaemon/appdaemon";
    changelog = "https://github.com/AppDaemon/appdaemon/blob/${version}/docs/HISTORY.rst";
    license = licenses.mit;
    maintainers = teams.home-assistant.members;
  };
}
