{ lib
, python3
, fetchFromGitHub
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      astral = super.astral.overridePythonAttrs (oldAttrs: rec {
        version = "1.10.1";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "1wbvnqffbgh8grxm07cabdpahlnyfq91pyyaav432cahqi1p59nj";
        };
      });

      bcrypt = super.bcrypt.overridePythonAttrs (oldAttrs: rec {
        version = "3.1.7";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "CwBpx1LsFBcsX3ggjxhj161nVab65v527CyA0TvkHkI=";
        };
      });

      yarl = super.yarl.overridePythonAttrs (oldAttrs: rec {
        version = "1.4.2";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "WM2cRp7O1VjNgao/SEspJOiJcEngaIno/yUQQ1t+90s=";
        };
      });
    };
  };

in python.pkgs.buildPythonApplication rec {
  pname = "appdaemon";
  version = "4.0.5";
  disabled = python.pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "AppDaemon";
    repo = pname;
    rev = version;
    sha256 = "7o6DrTufAC+qK3dDfpkuQMQWuduCZ6Say/knI4Y07QM=";
  };

  propagatedBuildInputs = with python.pkgs; [
    daemonize astral requests websocket_client aiohttp yarl jinja2
    aiohttp-jinja2 pyyaml voluptuous feedparser iso8601 bcrypt paho-mqtt setuptools
    deepdiff dateutil bcrypt python-socketio pid pytz sockjs pygments
    azure-mgmt-compute azure-mgmt-storage azure-mgmt-resource azure-keyvault-secrets azure-storage-blob
  ];

  # no tests implemented
  doCheck = false;

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "pyyaml==5.3" "pyyaml" \
      --replace "pid==2.2.5" "pid" \
      --replace "Jinja2==2.11.1" "Jinja2" \
      --replace "pytz==2019.3" "pytz" \
      --replace "aiohttp==3.6.2" "aiohttp>=3.6" \
      --replace "iso8601==0.1.12" "iso8601>=0.1" \
      --replace "azure==4.0.0" "azure-mgmt-compute
    azure-mgmt-storage
    azure-mgmt-resource
    azure-keyvault-secrets
    azure-storage-blob" \
      --replace "sockjs==0.10.0" "sockjs" \
      --replace "deepdiff==4.3.1" "deepdiff" \
      --replace "voluptuous==0.11.7" "voluptuous" \
      --replace "python-socketio==4.4.0" "python-socketio" \
      --replace "feedparser==5.2.1" "feedparser>=5.2.1" \
      --replace "aiohttp_jinja2==1.2.0" "aiohttp_jinja2>=1.2.0" \
      --replace "pygments==2.6.1" "pygments>=2.6.1" \
      --replace "paho-mqtt==1.5.0" "paho-mqtt>=1.5.0" \
      --replace "websocket-client==0.57.0" "websocket-client>=0.57.0"
  '';

  meta = with lib; {
    description = "Sandboxed Python execution environment for writing automation apps for Home Assistant";
    homepage = "https://github.com/AppDaemon/appdaemon";
    license = licenses.mit;
    maintainers = teams.home-assistant.members;
  };
}
