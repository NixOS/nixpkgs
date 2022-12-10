{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "appdaemon";
  version = "4.0.8";
  disabled = python3.pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "AppDaemon";
    repo = pname;
    rev = version;
    sha256 = "04a4qx0rbx2vpkzpibmwkpy7fawa6dbgqlrllryrl7dchbrf703q";
  };

  # relax dependencies
  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "deepdiff==5.2.3" "deepdiff" \
      --replace "pygments==2.8.1" "pygments"
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
    cchardet
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
    license = licenses.mit;
    maintainers = teams.home-assistant.members;
  };
}
